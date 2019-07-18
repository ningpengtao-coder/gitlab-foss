# frozen_string_literal: true

module Gitlab
  module Ci
    module Build
      module Prerequisite
        class AutoDevopsBuildable < Base
          def unmet?
            build.project.auto_devops_enabled? &&
              !build.project.has_auto_devops_explicitly_enabled? &&
              build.pipeline.auto_devops_buildable.nil? &&
              build.pipeline.auto_devops_source?
          end

          def complete!
            return unless unmet?

            build.pipeline.update!(auto_devops_buildable: auto_devops_buildable?)

            throw :unsupported unless build.pipeline.auto_devops_buildable?
          end

          private

          def auto_devops_buildable?
            !!Gitlab::AutoDevops::BuildableDetector.new(build.project, build.pipeline.sha).buildable?
          end
        end
      end
    end
  end
end
