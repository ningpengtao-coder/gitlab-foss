# frozen_string_literal: true

module Prometheus
  class UnicornPidProvider
    def initialize(for_master:)
      @for_master = for_master
    end

    def process_id
      @for_master ? 'unicorn_master' : worker_id
    end

    private

    def worker_id
      if match = process_name.match(/(unicorn|unicorn_rails) worker\[([0-9]+)\]/)
        "unicorn_#{match[2]}"
      else
        unknown_process_id
      end
    end

    def unknown_process_id
      "process_#{Process.pid}"
    end

    def process_name
      $0
    end
  end
end
