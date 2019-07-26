# frozen_string_literal: true

module BatchCount
  class ProjectsBatchCountWorker
    include ApplicationWorker
    include CronjobQueue
    include ExclusiveLeaseGuard

    IDENTIFIER = 'projects'
    LEASE_TIMEOUT = 5.minutes

    attr_reader :counter

    def initialize
      @counter = find_counter(IDENTIFIER)
    end

    def perform
      try_obtain_lease do
        update_with_batched_count(Project.all)
      end
    end

    def lease_timeout
      LEASE_TIMEOUT
    end

    private
    def find_counter(identifier)
      BackgroundCounter.find_or_create_by(identifier: identifier)
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    def update_with_batched_count(relation)
      counter.counter_value = Gitlab::Database::Count.batched_count(relation)
      counter.save!
    end
  end
end
