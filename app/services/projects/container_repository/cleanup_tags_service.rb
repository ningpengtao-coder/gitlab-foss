# frozen_string_literal: true

require 'set'

module Projects
  module ContainerRepository
    class CleanupTagsService < BaseService
      def execute(container_repository)
        return error('feature disabled') unless can_use?
        return error('access denied') unless can_clean_up_tags?

        tags = container_repository.tags
        tags_by_digest = group_by_digest(tags)

        if can_admin?
          tags = without_latest(tags)

          tags = if names_param.any?
                   filter_by_name(tags)
                 else
                   filter_by_regex(tags)
                 end

          tags = with_manifest(tags)
          tags = order_by_date(tags)
          tags = filter_keep_n(tags)
          tags = filter_by_older_than(tags)
        else
          return error('empty or missing names param') if names_param.empty?

          tags = filter_by_name(tags)
        end

        deleted_tags = delete_tags(tags, tags_by_digest)

        success(deleted: deleted_tags.map(&:name))
      end

      private

      def can_clean_up_tags?
        can_admin? || can_delete_tag?
      end

      def delete_tags(tags_to_delete, tags_by_digest)
        deleted_digests = group_by_digest(tags_to_delete).select do |digest, tags|
          delete_tag_digest(digest, tags, tags_by_digest[digest].size)
        end

        deleted_digests.values.flatten
      end

      def delete_tag_digest(digest, tags, same_digest_count)
        # if we are removing all tags for the digest,
        # just call .delete_image
        # as deleting one tag removes all tags and the image
        if tags.size == same_digest_count
          tags.first.delete_image
          tags
        else
          # delete the selected tags
          tags.map(&:delete)
        end
      end

      def group_by_digest(tags)
        tags.group_by(&:digest)
      end

      def without_latest(tags)
        tags.reject(&:latest?)
      end

      def with_manifest(tags)
        tags.select(&:valid?)
      end

      def order_by_date(tags)
        now = DateTime.now
        tags.sort_by { |tag| tag.created_at || now }.reverse
      end

      def filter_by_regex(tags)
        regex = Gitlab::UntrustedRegexp.new("\\A#{params['name_regex']}\\z")

        tags.select do |tag|
          regex.scan(tag.name).any?
        end
      end

      def names_param
        @names_param ||= (params['names'] || []).to_set
      end

      def filter_by_name(tags)
        tags.select do |tag|
          names_param.include?(tag.name)
        end
      end

      def filter_keep_n(tags)
        tags.drop(params['keep_n'].to_i)
      end

      def filter_by_older_than(tags)
        return tags unless params['older_than']

        older_than = ChronicDuration.parse(params['older_than']).seconds.ago

        tags.select do |tag|
          tag.created_at && tag.created_at < older_than
        end
      end

      def can_admin?
        can?(current_user, :admin_container_image, project)
      end

      def can_delete_tag?
        can?(current_user, :destroy_container_image, project)
      end

      def can_use?
        Feature.enabled?(:container_registry_cleanup, project, default_enabled: true)
      end
    end
  end
end
