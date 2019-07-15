# frozen_string_literal: true

FactoryBot.define do
  factory :project_pages_metadatum, class: ProjectPagesMetadatum do
    project
    deployed false
  end
end
