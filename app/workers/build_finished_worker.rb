# frozen_string_literal: true

class BuildFinishedWorker
  include ApplicationWorker
  include PipelineQueue

  JOB_DURATION_SECONDS_BUCKETS = [60, 300, 600, 1800, 3600, 7200, 21600, 86400].freeze

  queue_namespace :pipeline_processing

  # rubocop: disable CodeReuse/ActiveRecord
  def perform(build_id)
    Ci::Build.find_by(id: build_id).try do |build|
      process_build(build)
    end
  end
  # rubocop: enable CodeReuse/ActiveRecord

  private

  # Processes a single CI build that has finished.
  #
  # This logic resides in a separate method so that EE can extend it more
  # easily.
  #
  # @param [Ci::Build] build The build to process.
  def process_build(build)
    # We execute these in sync to reduce IO.
    BuildTraceSectionsWorker.new.perform(build.id)
    BuildCoverageWorker.new.perform(build.id)

    # We execute these async as these are independent operations.
    BuildHooksWorker.perform_async(build.id)
    ArchiveTraceWorker.perform_async(build.id)
    ExpirePipelineCacheWorker.perform_async(build.pipeline_id)
    ChatNotificationWorker.perform_async(build.id) if build.pipeline.chat?
  end

  def register_duration(build)
    runner_type = if build.runner
               build.runner.runner_type
             else
               :none
             end
    labels = { runner_type: runner_type }

    job_duration_seconds.observe(labels, build.duration)
  end

  def job_duration_seconds
    @job_duration_seconds ||= Gitlab::Metrics.histogram(:job_duration_seconds, 'Job execution time', {}, JOB_DURATION_SECONDS_BUCKETS)
  end
end
