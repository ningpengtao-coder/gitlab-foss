# frozen_string_literal: true

# For large tables, PostgreSQL can take a long time to count rows due to MVCC.
# We can optimize this by using various strategies for approximate counting.
#
# For example, we can use the reltuples count as described in https://wiki.postgresql.org/wiki/Slow_Counting.
#
# However, since statistics are not always up to date, we also implement a table sampling strategy
# that performs an exact count but only on a sample of the table. See TablesampleCountStrategy.
module Gitlab
  module Database
    module Count
      CONNECTION_ERRORS =
        if defined?(PG)
          [
            ActionView::Template::Error,
            ActiveRecord::StatementInvalid,
            PG::Error
          ].freeze
        else
          [
            ActionView::Template::Error,
            ActiveRecord::StatementInvalid
          ].freeze
        end

      # Takes in an array of models and returns a Hash for the approximate
      # counts for them.
      #
      # Various count strategies can be specified that are executed in
      # sequence until all tables have an approximate count attached
      # or we run out of strategies.
      #
      # Note that not all strategies are available on all supported RDBMS.
      #
      # @param [Array]
      # @return [Hash] of Model -> count mapping
      def self.approximate_counts(models, strategies: [TablesampleCountStrategy, ReltuplesCountStrategy, ExactCountStrategy])
        strategies.each_with_object({}) do |strategy, counts_by_model|
          models_with_missing_counts = models - counts_by_model.keys

          break counts_by_model if models_with_missing_counts.empty?

          counts = strategy.new(models_with_missing_counts).count

          counts.each do |model, count|
            counts_by_model[model] = count
          end
        end
      end

      # Performs an exact count on the given relation.
      #
      # It executes the counting in batches, which is useful on larger relations.
      # For batching to work, the a primary key needs to be specified. For models,
      # this gets automatically derived.
      #
      # Note the method must not be called inside a transaction.
      #
      # TODO: Optimize for memory with `select MAX(id), count(*) FROM (...)`
      def self.batched_count(relation, batch_size: 10000, primary_key: nil)
        raise "Batched counting must not run inside transaction" if ::Gitlab::Database.inside_transaction?

        primary_key ||= relation.primary_key if relation.respond_to?(:primary_key)

        relation.select(primary_key).find_in_batches(batch_size: batch_size).reduce(0) do |counter, batch|
          counter += batch.size
        end
      end
    end
  end
end
