# frozen_string_literal: true

module Namespaces
  class PruneAggregationSchedulesWorker
    include ApplicationWorker
    include CronjobQueue

    # Worker to prune pending rows on Namespace::AggregationSchedule
    # It's scheduled to run once a day at midnight.
    def perform
      aggregation_schedules.each do |aggregation_schedule|
        Namespaces::RootStatisticsWorker
          .perform_in(statistics_delay, aggregation_schedule.namespace_id)
      end
    end

    private

    def aggregation_schedules
      Namespace::AggregationSchedule.all
    end

    def statistics_delay
      Namespace::AggregationSchedule::STATISTICS_DELAY
    end
  end
end
