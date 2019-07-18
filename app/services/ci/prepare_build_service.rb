# frozen_string_literal: true

module Ci
  class PrepareBuildService
    attr_reader :build

    def initialize(build)
      @build = build
    end

    def execute
      catch :unsupported do
        prerequisites.each(&:complete!)

        build.enqueue!
        return # rubocop:disable Cop/AvoidReturnFromBlocks
      end

      build.pipeline.skip_all
    rescue => e
      Gitlab::Sentry.track_acceptable_exception(e, extra: { build_id: build.id })

      build.drop(:unmet_prerequisites)
    end

    private

    def prerequisites
      build.prerequisites
    end
  end
end
