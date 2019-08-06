# frozen_string_literal: true

class CycleAnalytics::CycleAnalyticsEntity < Grape::Entity
  include RequestAwareEntity

  expose :events, using: CycleAnalytics::EventEntity
  expose :stages, using: CycleAnalytics::StageEntity
  expose :summary
  expose :permissions

  def events
    Gitlab::CycleAnalytics::StageEvents.events
  end
end
