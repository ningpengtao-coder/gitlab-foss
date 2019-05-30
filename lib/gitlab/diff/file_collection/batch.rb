# frozen_string_literal: true

module Gitlab
  module Diff
    module FileCollection
      class Batch < Base
        def initialize(diffable, diff_options:)
          @batch_number = diff_options.fetch(:batch_number, 0)
          @batch_size = if @batch_number.zero?
                          ::Commit::INITIAL_FILES_BATCH
                        else
                          ::Commit::FILES_PER_BATCH
                        end

          diff_options[:expanded] = true unless @batch_number.zero?

          super(diffable,
                project: diffable.project,
                diff_options: diff_options,
                diff_refs: diffable.diff_refs)
        end

        def diff_files
          @diff_files ||= diffs.decorate_batch!(initial_diff_file, last_diff_file) { |diff| decorate_diff!(diff) }
        end

        private

        attr_reader :batch_number, :batch_size

        def initial_diff_file
          if batch_number.zero?
            0
          else
            last_diff_file - (batch_size - 1)
          end
        end

        def last_diff_file
          if @batch_number.zero?
            batch_size
          else
            batch_size + (batch_size * batch_number)
          end
        end
      end
    end
  end
end
