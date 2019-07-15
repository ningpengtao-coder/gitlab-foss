# frozen_string_literal: true

class ProjectPagesMetadatum < ApplicationRecord
  belongs_to :project, inverse_of: :project_pages_metadatum
end
