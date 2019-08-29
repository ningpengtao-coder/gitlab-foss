# frozen_string_literal: true

module Gitlab
  module ImportExport
    class ProjectHashSerializer
      CLASSES_TO_HASH = %w(Milestone).freeze

      attr_reader :project, :tree, :cache

      def initialize(project, tree)
        @project = project
        @tree = tree
        init_cache
      end

      def execute
        serializable_hash(project, tree)
      end

      private

      # From: https://github.com/rails/rails/blob/5-2-stable/activemodel/lib/active_model/serialization.rb
      # Updated for our case
      def serializable_hash(obj, options = nil)
        options ||= {}

        cached = get_cached_serialization(obj, options)
        return cached if cached

        attribute_names = obj.attributes.keys
        if only = options[:only]
          attribute_names &= Array(only).map(&:to_s)
        elsif except = options[:except]
          attribute_names -= Array(except).map(&:to_s)
        end

        hash = {}
        attribute_names.each { |n| hash[n] = obj.send(n) } # rubocop:disable GitlabSecurity/PublicSend
        Array(options[:methods]).each { |m| hash[m.to_s] = obj.send(m) } # rubocop:disable GitlabSecurity/PublicSend

        serializable_add_includes(obj, options) do |association, records, opts|
          res = []

          # in_batches doesn't work if the model doesn't have primary key
          if records.respond_to?(:to_ary) && records.model.primary_key.present?
            # Not all models use EachBatch, whereas ActiveRecord guarantees all models can use in_batches
            records.in_batches do |batch| # rubocop:disable Cop/InBatches
              res += batch.map { |el| serializable_hash(el, opts) }
            end
          elsif records.respond_to?(:to_ary)
            res = records.to_ary.map { |a| serializable_hash(a, opts) }
          else
            res = serializable_hash(records, opts)
          end

          hash[association.to_s] = res
        end

        cache_if_needed(obj, options, hash)

        hash
      end

      def get_cached_serialization(obj, options)
        return unless obj.class.name.in? CLASSES_TO_HASH

        cache[obj.class.name][obj.id]
      end

      def cache_if_needed(obj, options, hash)
        return unless obj.class.name.in? CLASSES_TO_HASH

        cache[obj.class.name][obj.id] = hash
      end

      def init_cache
        @cache = {}
        CLASSES_TO_HASH.each {|c| cache[c] = {}}
      end

      # From: https://github.com/rails/rails/blob/5-2-stable/activemodel/lib/active_model/serialization.rb
      #
      # Add associations specified via the <tt>:include</tt> option.
      #
      # Expects a block that takes as arguments:
      #   +association+ - name of the association
      #   +records+     - the association record(s) to be serialized
      #   +opts+        - options for the association records
      def serializable_add_includes(obj, options = {}) #:nodoc:
        return unless includes = options[:include]

        unless includes.is_a?(Hash)
          includes = Hash[Array(includes).map { |n| n.is_a?(Hash) ? n.to_a.first : [n, {}] }]
        end

        includes.each do |association, opts|
          if records = obj.send(association) # rubocop:disable GitlabSecurity/PublicSend
            yield association, records, opts
          end
        end
      end
    end
  end
end
