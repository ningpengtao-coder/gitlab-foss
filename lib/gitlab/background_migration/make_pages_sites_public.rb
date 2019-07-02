# frozen_string_literal: true

module Gitlab
  module BackgroundMigration
    # changes access level for pages sites to public and updates config
    class MakePagesSitesPublic
      # ProjectFeature
      class ProjectFeature < ApplicationRecord
        include ::EachBatch

        self.table_name = 'project_features'

        belongs_to :project

        ENABLED = 20
        PUBLIC = 30
      end

      def perform(start_id, stop_id)
        ProjectFeature.where(id: start_id..stop_id).where(pages_access_level: ProjectFeature::ENABLED)
          .joins(:project).where(projects: { visibility_level: [Project::PRIVATE, Project::INTERNAL] })
          .each_batch do |features|
          features.update_all(pages_access_level: ProjectFeature::PUBLIC)
        end
      end
    end
  end
end
