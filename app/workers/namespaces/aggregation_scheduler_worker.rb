# frozen_string_literal: true

module Namespaces
  class AggregationSchedulerWorker
    include ApplicationWorker

    queue_namespace :namespace

    def perform(namespace_id)
      return unless aggregation_schedules_table_exists?

      namespace = Namespace.find(namespace_id)

      return if namespace.aggregation_schedule.present?

      namespace.create_aggregation_schedule!
    rescue ActiveRecord::RecordNotFound => ex
      # Log error
    end

    private

    # On db/post_migrate/20180529152628_schedule_to_archive_legacy_traces.rb
    # traces are archived through build.trace.archive, which in consequence
    # calls UpdateProjectStatistics#schedule_namespace_statistics_worker.
    #
    # The migration fails since NamespaceAggregationSchedule table
    # does not exist at that point.
    def aggregation_schedules_table_exists?
      Namespace::AggregationSchedule.table_exists?
    end
  end
end
