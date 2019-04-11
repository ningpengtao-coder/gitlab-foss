# frozen_string_literal: true

module Gitlab
  module Ci
    module Build
      module Policy
        class Projects < Policy::Specification
          def initialize(projects)
            @paths = Array(projects)
          end

          def satisfied_by?(pipeline, seed = nil)
            @paths.any? do |path|
              matches_path?(path, pipeline)
            end
          end

          private

          def matches_path?(path, pipeline)
            return true unless path

            pipeline.project_full_path == path
          end
        end
      end
    end
  end
end
