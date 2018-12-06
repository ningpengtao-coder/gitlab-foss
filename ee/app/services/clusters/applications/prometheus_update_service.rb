# frozen_string_literal: true

module Clusters
  module Applications
    class PrometheusUpdateService < BaseHelmService
      attr_accessor :project

      def initialize(app, project)
        super(app)
        @project = project
      end

      def execute
        app.make_updating!

        values = helm_api
          .get_config_map(config_map_name)
          .yield_self { |response| extract_config(response) }
          .yield_self { |config| update_config(config) }
          .yield_self { |config| config.to_yaml }

        helm_api.update(upgrade_command(values))

        ::ClusterWaitForAppUpdateWorker.perform_in(::ClusterWaitForAppUpdateWorker::INTERVAL, app.name, app.id)
      rescue ::Kubeclient::HttpError => ke
        app.make_update_errored!("Kubernetes error: #{ke.message}")
      rescue StandardError => e
        app.make_update_errored!(e.message)
      end

      private

      def config_map_name
        ::Gitlab::Kubernetes::ConfigMap.new(app.name, app.files).config_map_name
      end

      def extract_config(response)
        YAML.safe_load(response.data[:'values.yaml'])
      end

      def update_config(config)
        PrometheusConfigService
          .new(project, cluster)
          .execute(config)
      end
    end
  end
end
