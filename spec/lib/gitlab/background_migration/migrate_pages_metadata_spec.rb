# frozen_string_literal: true

require 'rails_helper'

describe Gitlab::BackgroundMigration::MigratePagesMetadata, :migration, schema: 20190806112508 do
  let(:namespaces) { table(:namespaces) }
  let(:projects) { table(:projects) }
  let(:pages_metadata) { table(:project_pages_metadata) }

  let!(:namespace) { namespaces.create(name: 'gitlab', path: 'gitlab-org') }
  let!(:project_1) { projects.create(namespace_id: namespace.id, name: 'Project 1') }
  let!(:project_2) { projects.create(namespace_id: namespace.id, name: 'Project 2') }
  let!(:project_3) { projects.create(namespace_id: namespace.id, name: 'Project 3') }

  subject(:migration) { described_class.new }

  describe '#perform' do
    it 'creates pages metadata for the specified range of projects' do
      migration.perform(project_1.id, project_2.id)

      expect(pages_metadata.find_by_project_id(project_1.id)).to be_persisted
      expect(pages_metadata.find_by_project_id(project_2.id)).to be_persisted
      expect(pages_metadata.find_by_project_id(project_3.id)).to be_nil
    end
  end

  describe '#perform_on_relation' do
    it 'creates pages metadata for the specified projects' do
      migration.perform_on_relation(Project.where(id: project_2.id))

      expect(pages_metadata.find_by_project_id(project_1.id)).to be_nil
      expect(pages_metadata.find_by_project_id(project_2.id)).to be_persisted
      expect(pages_metadata.find_by_project_id(project_3.id)).to be_nil
    end
  end
end
