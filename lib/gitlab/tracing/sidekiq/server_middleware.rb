# frozen_string_literal: true

require 'opentracing'

module Gitlab
  module Tracing
    module Sidekiq
      class ServerMiddleware
        include SidekiqCommon

        def call(worker, job, queue)
          context = tracer.extract(OpenTracing::FORMAT_TEXT_MAP, job)

          start_active_span(
            operation_name: job['class'],
            child_of: context,
            tags: tags_from_job(job, 'server')) do |span|
            yield
          end
        end
      end
    end
  end
end
