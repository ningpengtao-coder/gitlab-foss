# frozen_string_literal: true

module Gitlab
  module Ci
    class Config
      module Entry
        ##
        # This class represents a global entry - root Entry for entire
        # GitLab CI Configuration file.
        #
        class Global < ::Gitlab::Config::Entry::Node
          include ::Gitlab::Config::Entry::Configurable

          entry :before_script, Entry::Script,
            description: 'Script that will be executed before each job.',
            inherit: true

          entry :image, Entry::Image,
            description: 'Docker image that will be used to execute jobs.',
            inherit: true

          entry :services, Entry::Services,
            description: 'Docker images that will be linked to the container.',
            inherit: true

          entry :after_script, Entry::Script,
            description: 'Script that will be executed after each job.',
            inherit: true

          entry :variables, Entry::Variables,
            description: 'Environment variables that will be used.',
            inherit: true

          entry :stages, Entry::Stages,
            description: 'Configuration of stages for this pipeline.',
            inherit: true

          entry :types, Entry::Stages,
            description: 'Configuration of stages for this pipeline.',
            inherit: true

          entry :cache, Entry::Cache,
            description: 'Configure caching between build jobs.',
            inherit: true

          entry :only, Entry::Policy,
            description: 'Refs policy this job will be executed for.',
            default: Entry::Policy::DEFAULT_GLOBAL_ONLY

          entry :except, Entry::Policy,
            description: 'Refs policy this job will be executed for.'

          helpers :before_script, :image, :services, :after_script,
                  :variables, :stages, :types, :cache, :only, :except

          def compose!(deps = nil)
            super(self) do
              inherit!(deps)
              compose_deprecated_entries!
            end
          end

          private

          def inherit!(deps)
            return unless deps

            self.class.nodes.each do |key, factory|
              next unless factory.inheritable?

              root_entry = deps[key]
              global_entry = self[key]

              if root_entry.specified? && !global_entry.specified?
                @entries[key] = root_entry
              end
            end
          end

          def compose_deprecated_entries!
            ##
            # Deprecated `:types` key workaround - if types are defined and
            # stages are not defined we use types definition as stages.
            #
            if types_defined? && !stages_defined?
              @entries[:stages] = @entries[:types]
            end

            @entries.delete(:types)
          end
        end
      end
    end
  end
end
