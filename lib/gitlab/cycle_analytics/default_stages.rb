# frozen_string_literal: true

module Gitlab
  module CycleAnalytics
    module DefaultStages
      def self.all
        [
          params_for_issue_stage,
          params_for_plan_stage,
          params_for_code_stage,
          params_for_test_stage,
          params_for_review_stage,
          params_for_staging_stage,
          params_for_production_stage
        ]
      end

      def self.params_for_issue_stage
        {
          name: 'issue',
          custom: false,
          relative_position: 1,
          start_event_identifier: :issue_created,
          end_event_identifier: :issue_stage_end
        }
      end

      def self.params_for_plan_stage
        {
          name: 'plan',
          custom: false,
          relative_position: 2,
          start_event_identifier: :plan_stage_start,
          end_event_identifier: :issue_first_mentioned_in_commit
        }
      end

      def self.params_for_code_stage
        {
          name: 'code',
          custom: false,
          relative_position: 3,
          start_event_identifier: :code_stage_start,
          end_event_identifier: :merge_request_created
        }
      end

      def self.params_for_test_stage
        {
          name: 'test',
          custom: false,
          relative_position: 4,
          start_event_identifier: :merge_request_last_build_started,
          end_event_identifier: :merge_request_last_build_finished
        }
      end

      def self.params_for_review_stage
        {
          name: 'review',
          custom: false,
          relative_position: 5,
          start_event_identifier: :merge_request_created,
          end_event_identifier: :merge_request_merged
        }
      end

      def self.params_for_staging_stage
        {
          name: 'staging',
          custom: false,
          relative_position: 6,
          start_event_identifier: :merge_request_merged,
          end_event_identifier: :merge_request_first_deployed_to_production
        }
      end

      def self.params_for_production_stage
        {
          name: 'production',
          custom: false,
          relative_position: 7,
          start_event_identifier: :merge_request_merged,
          end_event_identifier: :merge_request_first_deployed_to_production
        }
      end
    end
  end
end
