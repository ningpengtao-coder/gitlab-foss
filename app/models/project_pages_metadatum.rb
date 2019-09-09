# frozen_string_literal: true

class ProjectPagesMetadatum < ApplicationRecord
  self.primary_key = :project_id

  belongs_to :project, inverse_of: :project_pages_metadatum

  scope :project_scoped, -> { where('projects.id=project_pages_metadata.project_id') }
  scope :deployed, -> { where(deployed: true) }

  def self.update_pages_deployed(project, flag)
    flag = flag ? 'TRUE' : 'FALSE'

    upsert = <<~SQL
      INSERT INTO project_pages_metadata (project_id, deployed)
      VALUES (#{project.id.to_i}, #{flag})
      ON CONFLICT (project_id) DO UPDATE
      SET deployed = EXCLUDED.deployed
    SQL

    connection_pool.with_connection do |connection|
      connection.execute(upsert)
    end
  end
end
