# frozen_string_literal: true

class CycleAnalytics::EventEntity < Grape::Entity
  expose :name
  expose :identifier
  expose :type
  expose :can_be_start_event
  expose :allowed_end_events

  private

  def type
    'simple'
  end

  def can_be_start_event
    Gitlab::CycleAnalytics::StageEvents.pairing_rules.has_key?(object)
  end

  def allowed_end_events
    Gitlab::CycleAnalytics::StageEvents.pairing_rules.fetch(object, []).map(&:identifier)
  end
end
