# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'digest'

module ContainerRegistry
  class Client
    attr_accessor :uri

    DOCKER_DISTRIBUTION_MANIFEST_V2_TYPE = 'application/vnd.docker.distribution.manifest.v2+json'
    OCI_MANIFEST_V1_TYPE = 'application/vnd.oci.image.manifest.v1+json'
    CONTAINER_IMAGE_V1_TYPE = 'application/vnd.docker.container.image.v1+json'
    IMAGE_ROOTFS_DIFF_TYPE = 'application/vnd.docker.image.rootfs.diff.tar.gzip'

    ACCEPTED_TYPES = [DOCKER_DISTRIBUTION_MANIFEST_V2_TYPE, OCI_MANIFEST_V1_TYPE].freeze

    # Taken from: FaradayMiddleware::FollowRedirects
    REDIRECT_CODES = Set.new [301, 302, 303, 307]

    def initialize(base_uri, options = {})
      @base_uri = base_uri
      @options = options
    end

    def repository_tags(name)
      response_body faraday.get("/v2/#{name}/tags/list")
    end

    def repository_manifest(name, reference)
      response_body faraday.get("/v2/#{name}/manifests/#{reference}")
    end

    def repository_tag_digest(name, reference)
      response = faraday.head("/v2/#{name}/manifests/#{reference}")
      response.headers['docker-content-digest'] if response.success?
    end

    def delete_repository_tag(name, reference)
      faraday.delete("/v2/#{name}/manifests/#{reference}").success?
    end

    def upload_blob(name, content, digest)
      upload = faraday.post("/v2/#{name}/blobs/uploads/")

      location = URI(upload.headers['location'])

      faraday.put("#{location.path}?#{location.query}") do |req|
        req.params['digest'] = digest
        req.headers['Content-Type'] = 'application/octet-stream'
        req.body = content
      end
    end

    # Replace a tag on the registry with a dummy tag.
    # This is a hack as the registry doesn't support deleting individual
    # tags. This code effectively pushes a dummy image and assigns the tag to it.
    # This way when the tag is deleted only the dummy image is affected.
    # See https://gitlab.com/gitlab-org/gitlab-ce/issues/21405 for a discussion
    def put_dummy_tag(name, reference)
      # Docker doesn't seem to care for the actual content of these blobs,
      # so we're just uploading dummy gibberish
      image = "gitlab_dummy_image_container"
      rootfs = "gitlab_dummy_rootfs.tar.gz"

      blobs = [image, rootfs]

      digests = blobs.each_with_object({}) do |blob, hash|
        hash[blob] = "sha256:#{Digest::SHA256.hexdigest(blob)}"
      end

      # simply upload these fake blobs to docker registry
      digests.each_pair do |blob, digest|
        upload_blob(name, blob, digest)
      end

      # upload the replacement docker manifest for the tag,
      # so that it points to the dummy image
      upload_manifest(name, reference, digests: digests, image: image, rootfs: rootfs)
    end

    def blob(name, digest, type = nil)
      type ||= 'application/octet-stream'
      response_body faraday_blob.get("/v2/#{name}/blobs/#{digest}", nil, 'Accept' => type), allow_redirect: true
    end

    def delete_blob(name, digest)
      faraday.delete("/v2/#{name}/blobs/#{digest}").success?
    end

    private

    def upload_manifest(name, reference, digests:, image:, rootfs:)
      faraday.put("/v2/#{name}/manifests/#{reference}") do |req|
        req.headers['Content-Type'] = DOCKER_DISTRIBUTION_MANIFEST_V2_TYPE

        json = {
          schemaVersion: 2,
          mediaType: DOCKER_DISTRIBUTION_MANIFEST_V2_TYPE,
          config: {
            mediaType: CONTAINER_IMAGE_V1_TYPE,
            size: image.size,
            digest: digests[image]
          },
          layers: [
            {
              mediaType: IMAGE_ROOTFS_DIFF_TYPE,
              size: rootfs.size,
              digest: digests[rootfs]
            }
          ]
        }.to_json

        req.body = json
      end
    end

    def initialize_connection(conn, options)
      conn.request :json

      if options[:user] && options[:password]
        conn.request(:basic_auth, options[:user].to_s, options[:password].to_s)
      elsif options[:token]
        conn.request(:authorization, :bearer, options[:token].to_s)
      end

      yield(conn) if block_given?

      conn.adapter :net_http
    end

    def accept_manifest(conn)
      conn.headers['Accept'] = ACCEPTED_TYPES

      conn.response :json, content_type: 'application/json'
      conn.response :json, content_type: 'application/vnd.docker.distribution.manifest.v1+prettyjws'
      conn.response :json, content_type: 'application/vnd.docker.distribution.manifest.v1+json'
      conn.response :json, content_type: DOCKER_DISTRIBUTION_MANIFEST_V2_TYPE
      conn.response :json, content_type: OCI_MANIFEST_V1_TYPE
    end

    def response_body(response, allow_redirect: false)
      if allow_redirect && REDIRECT_CODES.include?(response.status)
        response = redirect_response(response.headers['location'])
      end

      response.body if response && response.success?
    end

    def redirect_response(location)
      return unless location

      uri = URI(@base_uri).merge(location)
      raise ArgumentError, "Invalid scheme for #{location}" unless %w[http https].include?(uri.scheme)

      faraday_redirect.get(uri)
    end

    def faraday
      @faraday ||= Faraday.new(@base_uri) do |conn|
        initialize_connection(conn, @options, &method(:accept_manifest))
      end
    end

    def faraday_blob
      @faraday_blob ||= Faraday.new(@base_uri) do |conn|
        initialize_connection(conn, @options)
      end
    end

    # Create a new request to make sure the Authorization header is not inserted
    # via the Faraday middleware
    def faraday_redirect
      @faraday_redirect ||= Faraday.new(@base_uri) do |conn|
        conn.request :json
        conn.adapter :net_http
      end
    end
  end
end
