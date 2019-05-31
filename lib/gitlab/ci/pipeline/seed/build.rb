# frozen_string_literal: true

module Gitlab
  module Ci
    module Pipeline
      module Seed
        class Build < Seed::Base
          include Gitlab::Utils::StrongMemoize

          delegate :dig, to: :@attributes

          def initialize(pipeline, attributes)
            @pipeline = pipeline
            @attributes = attributes

            @only = Gitlab::Ci::Build::Policy
              .fabricate(attributes.delete(:only))
            @except = Gitlab::Ci::Build::Policy
              .fabricate(attributes.delete(:except))
            @rules = Gitlab::Ci::Build::rules
              .fabricate(attributes.delete(:rules)
          end

          def included?
            strong_memoize(:inclusion) do
              only_policies_satisfied? && except_policies_satisfied? && included_by_rules?
            end
          end

          def attributes
            @attributes.merge(
              pipeline: @pipeline,
              project: @pipeline.project,
              user: @pipeline.user,
              ref: @pipeline.ref,
              tag: @pipeline.tag,
              trigger_request: @pipeline.legacy_trigger,
              protected: @pipeline.protected_ref?
            )
          end

          def bridge?
            @attributes.to_h.dig(:options, :trigger).present?
          end

          def to_resource
            strong_memoize(:resource) do
              if bridge?
                ::Ci::Bridge.new(attributes)
              else
                ::Ci::Build.new(attributes)
              end
            end
          end

          private

          def only_policies_satisfied?
            @only.all? { |spec| spec.satisfied_by?(@pipeline, self) }
          end

          def except_policies_satisfied?
            @except.none? { |spec| spec.satisfied_by?(@pipeline, self) }
          end

          def included_by_rules?
            # By default, jobs with no matching rule are included.
            matched_rule.nil? || matched_rule.includes_job?
          end

          def matched_rule
            @matched_rule ||= @rules.find { |rule| rule.matched_by?(@pipeline, self) }
          end
        end
      end
    end
  end
end
