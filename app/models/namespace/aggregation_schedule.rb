# frozen_string_literal: true

class Namespace::AggregationSchedule < ApplicationRecord
  include AfterCommitQueue

  STATISTICS_DELAY = 3.hours

  belongs_to :namespace

  after_create :schedule_root_storage_statistics

  private

  def schedule_root_storage_statistics
    run_after_commit do
      Namespaces::RootStatisticsWorker.perform_in(STATISTICS_DELAY, namespace_id)
    end
  end
end
