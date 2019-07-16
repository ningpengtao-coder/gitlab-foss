# frozen_string_literal: true

module Gitlab
  module Ci
    module Build
      ##
      # Abstract class that defines an interface of job policy
      # specification.
      #
      # Used for job's only/except policy configuration.
      #
      class Rules::Rule
        def initialize(spec)
          @outcome = spec.delete(:outcome)
          @clauses = spec.map { |type,  value| Clause.fabricate(type, value) }
        end

        def matched_by?(pipeline, seed = nil)
          @clauses.all? { |clause| clause.satisfied_by?(pipeline, seed) }
        end

        def includes_job?
          @outcome != 'drop'
        end
      end
    end
  end
end
