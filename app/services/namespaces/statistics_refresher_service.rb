# frozen_string_literal: true

module Namespaces
  class StatisticsRefresherService
    RefresherError = Class.new(StandardError)

    def execute(namespace)
      root_namespace = namespace.root_ancestor
      cte_query = projects_cte_query(root_namespace).first

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
      raise RefresherError.new("Namespaces statistics can't be updated for #{root_namespace.full_path}: #{e.message}")
    end

    private

    def projects_cte_query(namespace)
      query = build_projects_query(namespace)
      cte = Gitlab::SQL::CTE.new(:refresh_namespace_statistics, query)

      Project.with(cte.to_arel)
        .from(cte.alias_to(projects_table))
        .take(1)
    end

    def build_projects_query(namespace)
      namespace.all_projects
        .joins(routes_join, project_statistics_join)
        .select(project_statistics)
    end

    def projects_table
      Project.arel_table
    end

    def project_statistics_table
      ProjectStatistics.arel_table
    end

    def namespace_root_statistics_table
      Namespace::RootStorageStatistics.arel_table
    end

    def root_storage_statistics(root_namespace)
      root_namespace.root_storage_statistics ||
        root_namespace.create_root_storage_statistics!
    end

    def routes_table
      Route.arel_table
    end

    def routes_join
      projects_table
        .join(routes_table).on(route_id_matcher)
        .join_sources
    end

    def route_id_matcher
      routes_table[:source_id].eq(projects_table[:id])
        .and(routes_table[:source_type].eq('Project'))
    end

    def project_statistics_join
      projects_table
        .join(project_statistics_table).on(project_statistics_id_matcher)
        .join_sources
    end

    def project_statistics_id_matcher
      project_statistics_table[:project_id].eq(projects_table[:id])
    end

    def project_statistics
      [
        storage_size,
        repository_size,
        wiki_size,
        lfs_objects_size,
        build_artifacts_size,
        packages_size
      ]
    end

    def storage_size
      ProjectStatistics.arel_sum_column('storage_size')
    end

    def repository_size
      ProjectStatistics.arel_sum_column('repository_size')
    end

    def wiki_size
      ProjectStatistics.arel_sum_column('wiki_size')
    end

    def lfs_objects_size
      ProjectStatistics.arel_sum_column('lfs_objects_size')
    end

    def build_artifacts_size
      ProjectStatistics.arel_sum_column('build_artifacts_size')
    end

    def packages_size
      ProjectStatistics.arel_sum_column('packages_size')
    end
  end
end
