# frozen_string_literal: true

module Gitlab
  module Ci
    class Config
      module Entry
        class Rules < ::Gitlab::Config::Entry::Node
          include ::Gitlab::Config::Entry::Validatable

          validations do
            validates :config, presence: true
            validates :config, array_of_hashes: true
          end

          class Rule < ::Gitlab::Config::Entry::Node
            include ::Gitlab::Config::Entry::Validatable
            include ::Gitlab::Config::Entry::Attributable

            ALLOWED_KEYS = %i[if_expression changes outcome].freeze
            attributes :if_expression, :changes, :outcome

            def initialize(params)
              if if_expression = params.try(:key?, :if)
                params.merge!(if_expression: params.delete(:if))
              end

              super(params)
            end

            validations do
              validates :config, presence: true
              validates :config, type: { with: Hash }
              validates :config, allowed_keys: ALLOWED_KEYS
              validate  :if_expression_syntax

              with_options allow_nil: true do
                validates :if_expression, type: { with: String }
                validates :changes, array_of_strings: true
                validates :outcome, type: { with: String }
              end

              def if_expression_syntax
                return if if_expression.blank?

                ::Gitlab::Ci::Pipeline::Expression::Statement.new(if_expression.to_s).tap do |statement|
                  errors.add(:if_expression, 'Invalid expression syntax') unless statement.valid?
                end
              end
            end

            def default
            end
          end
        end
      end
    end
  end
end
