# frozen_string_literal: true

module Prometheus
  module PidProviderOld
    extend self

    def worker_id
      if Sidekiq.server?
        'sidekiq'
      # still need to check this or similar as PidProvider is called even before / outside of the
      # `Gitlab::Cluster::LifecycleEvents.on_master_start` hook
      elsif process_name =~ /(unicorn|unicorn_rails)\z/
        'unicorn_master'
      elsif elsif process_name =~ /puma/
        'puma_master'
      else
        unknown_process_id
      end
    end

    private

    def unknown_process_id
      "process_#{Process.pid}"
    end

    def process_name
      $0
    end
  end
end
