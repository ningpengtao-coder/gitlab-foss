# frozen_string_literal: true

module CycleAnalytics
  class ProjectStage < ApplicationRecord
    include CycleAnalytics::Stage

    belongs_to :project

    alias_attribute :parent, :project
  end
end
