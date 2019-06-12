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
      log_error(namespace.full_path, ex.message) if namespace
    end

    private

    def statistics_refresher_service
      @statistics_refresher_service ||= Namespaces::StatisticsRefresherService.new
    end

    def log_error(namespace_path, error_message)
      Gitlab::AppLogger.error("Namespace statistics can't be updated for #{namespace_path}: #{error_message}")
    end
  end
end
