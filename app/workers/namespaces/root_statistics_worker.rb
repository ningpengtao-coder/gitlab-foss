# frozen_string_literal: true

module Namespaces
  class RootStatisticsWorker
    include ApplicationWorker

    queue_namespace :namespace

    def perform(namespace_id)
      namespace = Namespace.find(namespace_id)

      return unless namespace.aggregation_scheduled?

      statistics_refresher_service.execute(namespace)
      namespace.aggregation_schedule.destroy
    rescue ::Namespaces::StatisticsRefresherService::RefresherError, ActiveRecord::RecordNotFound => ex
      # Log error
    end

    private

    def statistics_refresher_service
      @statistics_refresher_service ||= Namespaces::StatisticsRefresherService.new
    end
  end
end
