# frozen_string_literal: true

class CycleAnalytics::StageEntity < Grape::Entity
  expose :name
  expose :legend
  expose :description
  expose :id
  expose :relative_position, as: :position
  expose :hidden
  expose :custom
  expose :start_event_identifier
  expose :end_event_identifier

  def initialize(object, options = {})
    super(CycleAnalytics::StageDecorator.new(object), options)
  end

  def id
    object.id || object.name
  end
end
