# frozen_string_literal: true

module Namespaces
  class StatisticsRefresherService
    RefresherError = Class.new(StandardError)

    def execute(namespace)
      root_namespace = namespace.root_ancestor
      cte_query = Namespace::CteQuery.new(root_namespace).generate

      return if cte_query.nil?

      root_storage_statistics(root_namespace)
        .update(
          storage_size:         cte_query.storage_size,
          repository_size:      cte_query.repository_size,
          wiki_size:            cte_query.wiki_size,
          lfs_objects_size:     cte_query.lfs_objects_size,
          build_artifacts_size: cte_query.build_artifacts_size,
          packages_size:        cte_query.packages_size
        )
    rescue ActiveRecord::ActiveRecordError => e
      raise RefresherError.new(e.message)
    end

    private

    def root_storage_statistics(root_namespace)
      root_namespace.root_storage_statistics ||
        root_namespace.create_root_storage_statistics!
    end
  end
end
