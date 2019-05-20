# frozen_string_literal: true

module Gitlab
  module Diff
    module FileCollection
      class Batch < Base
        def initialize(commit, diff_options:)
          @batch_number = diff_options.fetch(:batch_number, 0)

          super(commit,
                project: commit.project,
                diff_options: diff_options,
                diff_refs: commit.diff_refs)
        end

        def diff_files
          @diff_files ||= diffs.decorate_batch!(initial_diff_file, last_diff_file) { |diff| decorate_diff!(diff) }
        end

        private

        attr_reader :batch_number

        def initial_diff_file
          if @batch_number.zero?
            0
          else
            last_diff_file - (::Commit::FILES_PER_BATCH - 1)
          end
        end

        def last_diff_file
          if @batch_number.zero?
            ::Commit::INITIAL_FILES_BATCH
          else
            ::Commit::INITIAL_FILES_BATCH + (::Commit::FILES_PER_BATCH * @batch_number)
          end
        end
      end
    end
  end
end
