# frozen_string_literal: true

module CycleAnalytics
  module Stage
    extend ActiveSupport::Concern

    included do
      validates :name, presence: true
      validate :validate_stage_event_pairs

      enum start_event_identifier: Gitlab::CycleAnalytics::StageEvents.to_enum, _prefix: :start_event_identifier
      enum end_event_identifier: Gitlab::CycleAnalytics::StageEvents.to_enum, _prefix: :end_event_identifier

      alias_attribute :custom_stage?, :custom
    end

    def parent=(_)
      raise NotImplementedError
    end

    def parent
      raise NotImplementedError
    end

    def start_event
      Gitlab::CycleAnalytics::StageEvents[start_event_identifier].new(params_for_start_event)
    end

    def end_event
      Gitlab::CycleAnalytics::StageEvents[end_event_identifier].new(params_for_end_event)
    end

    def params_for_start_event
      {}
    end

    def params_for_end_event
      {}
    end

    def default_stage?
      !custom
    end

    # The model that is going to be queried, Issue or MergeRequest
    def subject_model
      start_event.object_type
    end

    def matches_with_stage_params?(stage_params)
      default_stage? &&
        start_event_identifier == stage_params[:start_event_identifier] &&
        end_event_identifier == stage_params[:end_event_identifier]
    end

    private

    def validate_stage_event_pairs
      return if start_event_identifier.nil? || end_event_identifier.nil?

      unless Gitlab::CycleAnalytics::StageEvents.pairing_rules.fetch(start_event.class, []).include?(end_event.class)
        errors.add(:end_event, :not_allowed_for_the_given_start_event)
      end
    end
  end
end
