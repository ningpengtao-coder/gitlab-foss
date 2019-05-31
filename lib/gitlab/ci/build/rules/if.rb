# frozen_string_literal: true

module Gitlab
  module Ci
    module Build
      module Rules
        class If < Rules::Clause
          def initialize(expression)
            @expression = expression
          end

          def satisfied_by?(pipeline, seed)
            variables = seed.to_resource.scoped_variables_hash

            ::Gitlab::Ci::Pipeline::Expression::Statement
              .new(statement, variables).truthful?
          end
        end
      end
    end
  end
end
