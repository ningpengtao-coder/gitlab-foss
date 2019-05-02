# frozen_string_literal: true

module MergeRequests
  class CreatePipelineService < MergeRequests::BaseService
    def execute(merge_request)
      create_pipeline_for(merge_request).tap do |pipeline|
        merge_request.update_head_pipeline if pipeline&.persisted?
      end
    end
  end
end
