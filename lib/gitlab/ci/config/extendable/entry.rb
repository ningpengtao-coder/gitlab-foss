# frozen_string_literal: true

module Gitlab
  module Ci
    class Config
      class Extendable
        class Entry
          include Gitlab::Utils::StrongMemoize

          MAX_NESTING_LEVELS = 10

          attr_reader :key

          def initialize(key, context, parent = nil)
            @key = key
            @context = context
            @parent = parent
            @errors = []

            unless @context.key?(@key)
              raise StandardError, 'Invalid entry key!'
            end
          end

          def extensible?
            value.is_a?(Hash) && value.key?(:extends)
          end

          def value
            strong_memoize(:value) do
              @context.fetch(@key)
            end
          end

          def base_hashes!
            strong_memoize(:base_hashes) do
              extends_keys.map do |key|
                Extendable::Entry
                  .new(key, @context, self)
                  .extend!
              end
            end
          end

          def extends_keys
            strong_memoize(:extends_keys) do
              next unless extensible?

              Array(value.fetch(:extends)).map(&:to_s).map(&:to_sym)
            end
          end

          def ancestors
            strong_memoize(:ancestors) do
              Array(@parent&.ancestors) + Array(@parent&.key)
            end
          end

          def extend!
            return value unless extensible?

            validate!

            merged = {}
            base_hashes!.each { |h| merged.deep_merge!(h) }

            @context[key] = merged.deep_merge!(value)
          end

          private

          def validate!
            if unknown_extensions.any?
              @errors << { message: 'unknown keys found in `extends`', unknown_keys: show_keys(unknown_extensions) }
            end

            if invalid_bases.any?
              @errors << { message: 'invalid base hashes in `extends`', unknown_keys: show_keys(invalid_bases) }
            end

            if nesting_too_deep?
              @errors << { message: 'nesting too deep in `extends`' }
            end

            if circular_dependency?
              @errors << { message: 'circular dependency detected in `extends`' }
            end

            raise Extendable::ExtensionError, json_error_message if @errors.any?
          end

          def show_keys(keys)
            keys.join(', ')
          end

          def nesting_too_deep?
            ancestors.count > MAX_NESTING_LEVELS
          end

          def circular_dependency?
            ancestors.include?(key)
          end

          def unknown_extensions
            strong_memoize(:unknown_extensions) do
              extends_keys.reject { |key| @context.key?(key) }
            end
          end

          def invalid_bases
            strong_memoize(:invalid_bases) do
              extends_keys.reject { |key| @context[key].is_a?(Hash) }
            end
          end

          def json_error_message
            { key: key, context: @context, errors: @errors }.to_json
          end
        end
      end
    end
  end
end
