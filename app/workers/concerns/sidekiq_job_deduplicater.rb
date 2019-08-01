# frozen_string_literal: true

##
# Deduplicate sidekiq jobs with BatchPopQueueing.
#
# Often a sidekiq worker performs on the exact same argument for multiple times.
# This might make sense, however, it could be a waste of compute resource that
# sidekiq jobs are basically idempotent and results will likely be the same. Also,
# it could cause an unnecessary race condition that multiple jobs access the same
# data asynchronously.
#
# We can resolve such concerns by `SidekiqJobDeduplicater`, which
# processes a single item exclusively. When multiple sidekiq jobs are initiated
# with **the same argument**, the first item is executed and the following items
# are enqueued into a batch-pop-queue instead of an immediate execution.
# In this enqueueing process, the system removes duplicate items proactively, thus
# the next item is always one, becuase we enqueue the same item to the queue.
# Once sidekiq job finished to work on the first item, it works on the
# same item again, which ensures that all sidekiq jobs are processed after
# the enqueueing.
#
# NOTE:
# - Currently, this class is not compatible with multiple arguments in sidekiq classes.
# - If the sidekiq worker is often killed by sidekiq memory killer due to the memory consumption,
#   the exclusive lock might linger in Redis and it could interrupt the next execution.
module SidekiqJobDeduplicater
  extend ActiveSupport::Concern
  extend ::Gitlab::Utils::Override

  prepended do
    class_attribute :deduplicater_default_enabled
    class_attribute :deduplicater_lock_timeout

    # The deduplicater is behind a feature flag and you can disable the behavior
    # by disabling the feature flag.
    # The deduplicater is enabled by default, if you want to disable by default,
    # set `false` to the `deduplicater_default_enabled` vaule.
    self.deduplicater_default_enabled = true

    # The deduplicater runs the process in an exclusive lock and while the lock
    # is effective the duplicate sidekiq jobs will be absorbed or defered after
    # the current process finishes.
    # Basically, you should set `deduplicater_lock_timeout` a greater vaule than
    # the maximum execution time of the sidekiq job.
    self.deduplicater_lock_timeout = 10.minutes
  end

  override :perform
  def perform(arg)
    if Feature.enabled?(feature_flag_name, default_enabled: deduplicater_default_enabled)
      result = Gitlab::BatchPopQueueing.new(sanitized_worker_name, arg.to_s)
                                       .safe_execute([arg], lock_timeout: deduplicater_lock_timeout) do |items|
        super(items.first)
      end

      if result[:status] == :finished && result[:new_items].present?
        self.class.perform_async(result[:new_items].first)
      end
    else
      super(arg)
    end
  end

  private

  def sanitized_worker_name
    self.class.name.underscore
  end

  def feature_flag_name
    "enable_deduplicater_for_#{sanitized_worker_name}"
  end
end
