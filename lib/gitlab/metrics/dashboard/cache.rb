# frozen_string_literal: true

require 'set'

module Gitlab
  module Metrics
    module Dashboard
      class Cache
        CACHE_KEYS = 'all_cached_metric_dashboards'

        class << self
          # Stores a dashboard in the cache, documenting the key
          # so the cached can be cleared in bulk at another time.
          def fetch(key)
            register_key(key)

            Gitlab::Cache::Store.main.fetch(key) { yield }
          end

          # Resets all dashboard caches, such that all
          # dashboard content will be loaded from source on
          # subsequent dashboard calls.
          def delete_all!
            all_keys.each { |key| Gitlab::Cache::Store.main.delete(key) }

            Gitlab::Cache::Store.main.delete(CACHE_KEYS)
          end

          private

          def register_key(key)
            new_keys = all_keys.add(key).to_a.join('|')

            Gitlab::Cache::Store.main.write(CACHE_KEYS, new_keys)
          end

          def all_keys
            Set.new(Gitlab::Cache::Store.main.read(CACHE_KEYS)&.split('|'))
          end
        end
      end
    end
  end
end
