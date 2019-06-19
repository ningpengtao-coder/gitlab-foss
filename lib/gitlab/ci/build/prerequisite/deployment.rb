# frozen_string_literal: true

module Gitlab
  module Ci
    module Build
      module Prerequisite
        class Deployment < Base
          def unmet?
            build.starts_environment? && !build.has_deployment?
          end

          def complete!
            return unless unmet?

            build.create_deployment
          end
        end
      end
    end
  end
end
