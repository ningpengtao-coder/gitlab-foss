# frozen_string_literal: true

require 'opentracing'

module Gitlab
  module Tracing
    module Rails
      def self.instrument
        ActiveSupport::Notifications.subscribe('sql.active_record') do |_, start, finish, _, payload|
          operation_name = payload.fetch(:name)

          connection_config = ActiveRecord::Base.connection_config

          trace_rails_instrumentation(operation_name: operation_name || "sql.query",
                                      start_time: start,
                                      end_time: finish,
                                      tags: {
                                        :'component' => 'ActiveRecord',
                                        :'span.kind' => 'client',
                                        :'db.instance' => connection_config.fetch(:database),
                                        :'db.vendor' => connection_config.fetch(:adapter),
                                        :'db.connection_id' => payload.fetch(:connection_id, 'unknown'),
                                        :'db.cached' => payload.fetch(:cached, false),
                                        :'db.statement' => payload.fetch(:sql),
                                        :'db.type' => 'sql'
                                      },
                                      exception: payload[:exception])
        end

        ActiveSupport::Notifications.subscribe("render_template.action_view") do |_, start, finish, _, payload|
          trace_rails_instrumentation(
            operation_name:      'template.render',
            start_time:          start,
            end_time:            finish,
            tags: {
              :component =>         'ActionView',
              :'span.kind' =>       'client',
              :'template.id' =>     payload.fetch(:identifier),
              :'template.layout' => payload.fetch(:layout)
            },
            exception:           payload[:exception])
        end
      end

      private

      def self.trace_rails_instrumentation(operation_name:, start_time:, end_time:, tags:, exception:)
        span = OpenTracing.start_span(operation_name,
          start_time: start_time,
          tags: tags)

        log_exception_on_span(span, exception) if exception

        span.finish(end_time: end_time)
      end
    end
  end
end

