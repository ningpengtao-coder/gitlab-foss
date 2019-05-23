# frozen_string_literal: true

class UpdateHeadPipelineForMergeRequestWorker
  include ApplicationWorker
  include PipelineQueue

  queue_namespace :pipeline_processing

  def perform(merge_request_id)
    MergeRequest.find_by_id(merge_request_id).try(&:update_head_pipeline)
  end
end
