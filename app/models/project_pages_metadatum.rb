# frozen_string_literal: true

class ProjectPagesMetadatum < ApplicationRecord
  self.primary_key = :project_id

  belongs_to :project, inverse_of: :project_pages_metadatum

  scope :project_scoped, -> { where('projects.id=project_pages_metadata.project_id') }
end
