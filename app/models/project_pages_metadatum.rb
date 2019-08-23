# frozen_string_literal: true

class ProjectPagesMetadatum < ApplicationRecord
  MINIMUM_SCHEMA_VERSION = 20190806112508

  self.primary_key = :project_id

  belongs_to :project, inverse_of: :project_pages_metadatum

  scope :project_scoped, -> { where('projects.id=project_pages_metadata.project_id') }

  def self.available?
    @available ||=
      ActiveRecord::Migrator.current_version >= MINIMUM_SCHEMA_VERSION
  end

  def self.reset_column_information
    @available = nil
    super
  end
end
