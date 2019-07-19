# frozen_string_literal: true

module Gitlab
  module Cache
    # See https://docs.gitlab.com/ee/development/utilities.html#cachestore
    module Store
      def self.cache
        @level1 || init_level_1_cache
      end

      # Allow the l1 cache to be overridden for testing purposes
      def self.cache=(rhs)
        @level1 = rhs
      end

      def self.main
        @level2 || init_level_2_cache
      end

      # Allow the main cache to be overridden for testing purposes
      def self.main=(rhs)
        @level2 = rhs
      end

      def self.init_level_1_cache
        init_cache

        @level1
      end
      private_class_method :init_level_1_cache

      def self.init_level_2_cache
        init_cache

        @level2
      end
      private_class_method :init_level_2_cache

      def self.init_cache
        l1_cache_size_mb = ENV['GITLAB_L1_RAILS_CACHE_SIZE_MB'].to_i

        if l1_cache_size_mb > 0
          @level2 = create_redis_cache_store
          @level1 = ActiveSupport::Cache.lookup_store(:level2, {
            L1: create_inmemory_store(l1_cache_size_mb),
            L2: @level2
          })
        else
          @level1 = @level2 = create_redis_cache_store
        end
      end
      private_class_method :init_cache

      def self.create_inmemory_store(l1_cache_size_mb)
        ActiveSupport::Cache.lookup_store(:memory_store, size: l1_cache_size_mb.megabytes, expires_in: 1.minute, race_condition_ttl: 1.second)
      end
      private_class_method :create_inmemory_store

      def self.create_redis_cache_store
        # Use caching across all environments
        caching_config_hash = Gitlab::Redis::Cache.params
        caching_config_hash[:namespace] = Gitlab::Redis::Cache::CACHE_NAMESPACE
        caching_config_hash[:expires_in] = 2.weeks # Cache should not grow forever
        if Sidekiq.server? # threaded context
          caching_config_hash[:pool_size] = Sidekiq.options[:concurrency] + 5
          caching_config_hash[:pool_timeout] = 1
        end

        ActiveSupport::Cache.lookup_store(:redis_store, caching_config_hash)
      end
      private_class_method :create_redis_cache_store
    end



  end
end
