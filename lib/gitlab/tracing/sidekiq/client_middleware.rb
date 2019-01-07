# frozen_string_literal: true

require 'opentracing'

module Gitlab
  module Tracing
    module Sidekiq
      class ClientMiddleware
        include SidekiqCommon

        def call(worker_class, job, queue, redis_pool)
          start_active_span(
            operation_name: job['class'],
            tags: tags_from_job(job, 'client')) do |span|
            # Inject the details directly into the job
            tracer.inject(span.context, OpenTracing::FORMAT_TEXT_MAP, job)
            yield
          end
        end
      end
    end
  end
end
