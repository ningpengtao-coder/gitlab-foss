# frozen_string_literal: true

module Gitlab
  module ImportExport
    class Config
      def initialize(project = nil)
        @project = project
      end

      # Returns a Hash of the YAML file
      def to_h
        hash = parse_yaml.dup

        # The YAML file contains `ee` settings. The EE-specific
        # Gitlab::ImportExport::Config module handles these.
        hash.delete('ee')

        # Merge in any feature flagged project tree properties that are enabled
        merge_feature_flagged_project_tree!(hash)

        hash
      end

      private

      attr_accessor :project

      # Merges any project tree relationships defined under a `feature_flag.project_tree` key
      # if the feature is enabled for the project
      def merge_feature_flagged_project_tree!(hash)
        flagged_hash = hash.delete('feature_flagged')
        return unless flagged_hash && project

        flagged_hash.each do |flag_name, flagged_tree|
          default_enabled = flagged_tree.delete('default_enabled')

          next unless Feature.enabled?(flag_name, @project, default_enabled: default_enabled)

          merge_project_tree!(flagged_tree['project_tree'], hash['project_tree'])
        end
      end

      # Merges a project relationships tree into the target tree.
      #
      # @param [Array<Hash|Symbol>] source_values
      # @param [Array<Hash|Symbol>] target_values
      def merge_project_tree!(source_values, target_values)
        source_values.each do |value|
          if value.is_a?(Hash)
            # Examples:
            #
            # { 'project_tree' => [{ 'labels' => [...] }] }
            # { 'notes' => [:author, { 'events' => [:push_event_payload] }] }
            value.each do |key, val|
              target = target_values
                .find { |h| h.is_a?(Hash) && h[key] }

              if target
                merge_project_tree!(val, target[key])
              else
                target_values << { key => val.dup }
              end
            end
          else
            # Example: :priorities, :author, etc
            target_values << value
          end
        end
      end

      def parse_yaml
        @parse_yaml ||= YAML.load_file(Gitlab::ImportExport.config_file)
      end
    end
  end
end

Gitlab::ImportExport::Config.prepend_if_ee('EE::Gitlab::ImportExport::Config')
