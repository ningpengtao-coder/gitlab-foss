module Prometheus
  class PumaPidProvider
    def initialize(for_master:)
      @for_master = for_master
    end

    def process_id
      @for_master ? 'puma_master' : worker_id
    end

    private

    def worker_id
      match = process_name.match(/cluster worker ([0-9]+):/)
      match ? "puma_#{match[1]}" : unknown_process_id
    end

    def unknown_process_id
      "process_#{Process.pid}"
    end

    def process_name
      $0
    end
  end
end
