# frozen_string_literal: true

class Namespace::CteQuery
  def initialize(namespace)
    @namespace = namespace
  end

  def generate
    cte = Gitlab::SQL::CTE.new(:refresh_namespace_statistics, query)

    Project.with(cte.to_arel)
      .from(cte.alias_to(projects_table))[0]
  end

  private

  attr_reader :namespace

  def query
    namespace.all_projects
      .joins(routes_join, project_statistics_join)
      .select(project_statistics)
  end

  def routes_join
    projects_table
      .join(routes_table).on(route_id_matcher)
      .join_sources
  end

  def project_statistics_join
    projects_table
      .join(project_statistics_table).on(project_statistics_id_matcher)
      .join_sources
  end

  def projects_table
    Project.arel_table
  end

  def project_statistics_table
    ProjectStatistics.arel_table
  end

  def routes_table
    Route.arel_table
  end

  def route_id_matcher
    routes_table[:source_id].eq(projects_table[:id])
      .and(routes_table[:source_type].eq('Project'))
  end

  def project_statistics_id_matcher
    project_statistics_table[:project_id].eq(projects_table[:id])
  end

  def project_statistics
    [
      project_statistics_arel_sum_column('storage_size'),
      project_statistics_arel_sum_column('repository_size'),
      project_statistics_arel_sum_column('wiki_size'),
      project_statistics_arel_sum_column('lfs_objects_size'),
      project_statistics_arel_sum_column('build_artifacts_size'),
      project_statistics_arel_sum_column('packages_size')
    ]
  end

  def project_statistics_arel_sum_column(column_name)
    Arel::Nodes::NamedFunction.new(
      'COALESCE', [project_statistics_table[column_name.to_sym].sum, 0]
    ).as(column_name)
  end
end
