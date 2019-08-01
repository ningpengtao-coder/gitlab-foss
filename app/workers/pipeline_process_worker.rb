# frozen_string_literal: true

class PipelineProcessWorker
  include ApplicationWorker
  include PipelineQueue
  prepend SidekiqJobDeduplicater

  queue_namespace :pipeline_processing

  self.deduplicater_default_enabled = false

  def perform(pipeline_id, build_ids = nil)
    Ci::Pipeline.find_by_id(pipeline_id).try do |pipeline|
      pipeline.process!(build_ids)
    end
  end
end
