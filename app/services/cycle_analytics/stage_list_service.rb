# frozen_string_literal: true

module CycleAnalytics
  class StageListService
    def initialize(parent:, allowed_to_customize_stages: false)
      @parent = parent
      @allowed_to_customize_stages = allowed_to_customize_stages
    end

    def execute
      if allowed_to_customize_stages
        raise NotImplementedError # will be implemented in EE
      else
        build_default_stages
      end
    end

    private

    attr_reader :parent, :allowed_to_customize_stages

    def build_default_stages
      Gitlab::CycleAnalytics::DefaultStages.all.map do |params|
        parent.cycle_analytics_stages.build(params)
      end
    end
  end
end
