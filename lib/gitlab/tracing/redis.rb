# frozen_string_literal: true

require 'opentracing'

module Gitlab
  module Tracing
    module Redis
      include Common

      MAX_SENT_REDIS_COMMAND_LENGTH = 240

      def self.instrument_client
        ::Redis::Client.class_exec do
          prepend RedisTracingInstrumented
        end
      end

      private

      module RedisTracingInstrumented
        include Common
        def call(*args, &block)
          # For Redis calls, certain systems (Sidekiq in particular) will poll Redis
          # periodically, outside of a trace scope. In this event, don't trace the
          # call
          scope = OpenTracing.scope_manager.active
          return super(*args, &block) unless scope

          start_active_span(operation_name: "redis.call",
            tags: {
              :component =>       'redis',
              :'span.kind' =>     'client',
              :'db.host' =>       self.host,
              :'db.port' =>       self.port,
              :'redis.db' =>      self.db,
              :'redis.command' => quantize_redis_arguments(*args),
              :'redis.args.count' => args.length
            }) do |span|
            super(*args, &block)
          end
        end

        # Turns an array of redis arguments into a trace-worthy string
        def quantize_redis_arguments(args)
          args.inject("") do |memo, arg|
            str = ""
            begin
              str = arg.to_s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
            rescue
              # Don't stumble on encoding errors while generating tracing
              str = "?"
            end

            str = str.slice(0, 19) + "…" if str.length > 20

            memo = memo == "" ? str : memo + " " + str
            if memo.length > MAX_SENT_REDIS_COMMAND_LENGTH
              memo = memo.slice(0, MAX_SENT_REDIS_COMMAND_LENGTH - 1) + "…"
              # No need to iterate over the rest of the arguments
              break memo
            end

            memo
          end
        end
      end
    end
  end
end

