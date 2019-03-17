# frozen_string_literal: true

module Gitlab
  module Kubernetes
    module Knative
      class Service
        attr_reader :name, :namespace, :image

        def initialize(name, namespace, image)
          @name = name
          @namespace = namespace
          @image = image
        end

        def generate
          resource = ::Kubeclient::Resource.new
          resource.metadata = metadata
          resource.spec = spec
          resource
        end

        private

        def metadata
          {
            name: name,
            namespace: namespace
          }
        end

        # One of "runLatest", "release", "pinned" (DEPRECATED), or "manual"
        # https://github.com/knative/serving/blob/master/docs/spec/spec.md#service
        def spec
          { "runLatest": configuration }
        end

        def configuration
          {
            configuration: {
              revisionTemplate: {
                spec: {
                  container: { image: image }
                }
              }
            }
          }
        end
      end
    end
  end
end
