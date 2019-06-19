# frozen_string_literal: true

module Namespaces
  class StatisticsRefresherService
    RefresherError = Class.new(StandardError)

    def execute(root_namespace)
      root_storage_statistics(root_namespace).recalculate!
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
