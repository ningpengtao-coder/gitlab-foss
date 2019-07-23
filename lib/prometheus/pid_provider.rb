# frozen_string_literal: true

require 'prometheus/client/support/unicorn'

module Prometheus
  module PidProvider
    extend self

    def worker_id
      if Sidekiq.server?
        'sidekiq'
      elsif defined?(Unicorn::Worker)
        unicorn_worker_id
      elsif defined?(::Puma)
        puma_worker_id
      else
        unknown_process_id
      end
    end

    private

    def unicorn_worker_id
      if process_name =~ /unicorn_rails master/
        'unicorn_master'
      elsif match = process_name.match(/unicorn_rails worker\[([0-9]+)\]/)
        "unicorn_#{match[1]}"
      else
        unknown_process_id
      end
    end

    # This is not fully accurate as we don't really know if the nil returned
    # is actually means we're on master or not.
    # Follow up issue was created to address this problem and
    # to introduce more structrured approach to a current process discovery:
    # https://gitlab.com/gitlab-org/gitlab-ce/issues/64740
    def puma_worker_id
      match = process_name.match(/cluster worker ([0-9]+):/)
      match ? "puma_#{match[1]}" : 'puma_master'
    end

    def unknown_process_id
      "process_#{Process.pid}"
    end

    def process_name
      $0
    end
  end
end
