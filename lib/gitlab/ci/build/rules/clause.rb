# frozen_string_literal: true

module Gitlab
  module Ci
    module Build
      module Rules
        class Rule
          ##
          # Abstract class that defines an interface of a single
          # job rule specification.
          #
          # Used for job's inclusion rules configuration.
          #
          class Clause
            UnknownClauseError = Class.new(StandardError)

            def initialize(spec)
              @spec = spec
            end

            def satisfied_by?(pipeline, seed = nil)
              raise NotImplementedError
            end
          end
        end
      end
    end
  end
end
