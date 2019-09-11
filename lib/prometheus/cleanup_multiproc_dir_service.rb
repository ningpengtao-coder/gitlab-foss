# frozen_string_literal: true

module Prometheus
  class CleanupMultiprocDirService
    include Gitlab::Utils::StrongMemoize

    def execute
      FileUtils.rm_rf(old_metrics) if old_metrics

      log_cleanup
    end

    private

    def old_metrics
      strong_memoize(:old_metrics) do
        if multiprocess_files_dir
          # TODO: remove `.select {}` part after investigating
          # https://gitlab.com/gitlab-org/gitlab-ce/issues/66889
          Dir[File.join(multiprocess_files_dir, '*.db')].select {|f| f !~ /gauge_all_unicorn_master/}
        end
      end
    end

    def multiprocess_files_dir
      ::Prometheus::Client.configuration.multiprocess_files_dir
    end

    def log_cleanup
      message = "Cleanup Prometheus multiprocess_files_dir, pid: #{Process.pid}"
      Gitlab::AppLogger.info(message)
    end
  end
end
