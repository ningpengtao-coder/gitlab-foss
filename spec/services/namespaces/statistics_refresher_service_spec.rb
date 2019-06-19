# frozen_string_literal: true

require 'spec_helper'

describe Namespaces::StatisticsRefresherService, '#execute' do
  let(:group) { create(:group) }
  let(:projects) { create_list(:project, 5, namespace: group) }
  let(:service) { described_class.new }

  context 'when namespace has projects' do
    before do
      projects.each do |project|
        project.statistics.update(
          storage_size: 1_000,
          repository_size: 1_000,
          lfs_objects_size: 2_000,
          build_artifacts_size: 500,
          packages_size: 600,
          wiki_size: 300
        )
      end
    end

    context 'and no root storage statistics relation' do
      it 'creates one' do
        expect do
          service.execute(group)
        end.to change(Namespace::RootStorageStatistics, :count).by(1)
      end

      it 'sets the namespaces statistics' do
        service.execute(group)

        root_statistics = group.reload.root_storage_statistics
        project_statistics = ProjectStatistics.where(namespace_id: group.id)

        expect(root_statistics).to be_persisted
        expect(root_statistics.storage_size).to eq(project_statistics.sum(:storage_size))
        expect(root_statistics.repository_size).to eq(project_statistics.sum(:repository_size))
        expect(root_statistics.lfs_objects_size).to eq(project_statistics.sum(:lfs_objects_size))
        expect(root_statistics.build_artifacts_size).to eq(project_statistics.sum(:build_artifacts_size))
        expect(root_statistics.packages_size).to eq(project_statistics.sum(:packages_size))
        expect(root_statistics.wiki_size).to eq(project_statistics.sum(:wiki_size))
      end
    end

    context 'and root storage statistics relation' do
      let(:group) { create(:group, :with_root_storage_statistics) }
      let(:root_statistics) { group.root_storage_statistics }

      it 'updates existing one' do
        expect do
          service.execute(group)
        end.not_to change(Namespace::RootStorageStatistics, :count)
      end

      it 'updates the existing statistics' do
        service.execute(group)

        root_statistics.reload
        project_statistics = ProjectStatistics.where(namespace_id: group.id)

        expect(root_statistics).to be_persisted
        expect(root_statistics.storage_size).to eq(project_statistics.sum(:storage_size))
        expect(root_statistics.repository_size).to eq(project_statistics.sum(:repository_size))
        expect(root_statistics.lfs_objects_size).to eq(project_statistics.sum(:lfs_objects_size))
        expect(root_statistics.build_artifacts_size).to eq(project_statistics.sum(:build_artifacts_size))
        expect(root_statistics.packages_size).to eq(project_statistics.sum(:packages_size))
        expect(root_statistics.wiki_size).to eq(project_statistics.sum(:wiki_size))
      end
    end

    context 'when something goes wrong' do
      before do
        allow_any_instance_of(Namespace::RootStorageStatistics)
          .to receive(:recalculate!).and_raise(ActiveRecord::ActiveRecordError)
      end

      it 'raises RefreshError' do
        expect do
          service.execute(group)
        end.to raise_error(Namespaces::StatisticsRefresherService::RefresherError)
      end
    end
  end

  context 'when namespace does not have projects' do
    it 'sets the namespaces statistics to 0' do
      service.execute(group)

      root_statistics = group.root_storage_statistics
      expect(root_statistics).to be_persisted
      expect(root_statistics.storage_size).to eq(0.0)
      expect(root_statistics.repository_size).to eq(0.0)
      expect(root_statistics.lfs_objects_size).to eq(0.0)
      expect(root_statistics.build_artifacts_size).to eq(0.0)
      expect(root_statistics.packages_size).to eq(0.0)
      expect(root_statistics.wiki_size).to eq(0.0)
    end
  end

  context 'when namespace has subgroups' do
    let(:subgroup) { create(:group, parent: group) }
    let(:projects_in_subgroup) { create_list(:project, 3, namespace: subgroup) }

    before do
      projects_in_subgroup.each do |project|
        project.statistics.update(
          storage_size: 1_000,
          repository_size: 1_000,
          lfs_objects_size: 2_000,
          build_artifacts_size: 500,
          packages_size: 600,
          wiki_size: 300
        )
      end
    end

    it 'updates root statistics with subgroups details' do
      service.execute(group)

      all_projects = group.all_projects
      all_project_statistics = ProjectStatistics.where(project_id: all_projects)
      root_statistics = group.reload.root_storage_statistics

      expect(root_statistics).to be_persisted
      expect(root_statistics.storage_size).to eq(all_project_statistics.sum(:storage_size))
      expect(root_statistics.repository_size).to eq(all_project_statistics.sum(:repository_size))
      expect(root_statistics.lfs_objects_size).to eq(all_project_statistics.sum(:lfs_objects_size))
      expect(root_statistics.build_artifacts_size).to eq(all_project_statistics.sum(:build_artifacts_size))
      expect(root_statistics.packages_size).to eq(all_project_statistics.sum(:packages_size))
      expect(root_statistics.wiki_size).to eq(all_project_statistics.sum(:wiki_size))
    end
  end

  context 'with projects from another group' do
    let(:another_group) { create(:group) }
    let(:other_projects) { create_list(:project, 10, namespace: another_group) }

    before do
      projects.each do |project|
        project.statistics.update(
          storage_size: 1_000,
          repository_size: 1_000,
          lfs_objects_size: 2_000,
          build_artifacts_size: 500,
          packages_size: 600,
          wiki_size: 300
        )
      end

      other_projects.each do |project|
        project.statistics.update(
          storage_size: 10,
          repository_size: 10,
          lfs_objects_size: 20,
          build_artifacts_size: 50,
          packages_size: 60,
          wiki_size: 30
        )
      end
    end

    it 'ignores outsider projects' do
      service.execute(group)

      project_statistics = ProjectStatistics.where(namespace_id: group.id)
      root_statistics = group.reload.root_storage_statistics

      expect(root_statistics.storage_size).to eq(project_statistics.sum(:storage_size))
      expect(root_statistics.repository_size).to eq(project_statistics.sum(:repository_size))
      expect(root_statistics.lfs_objects_size).to eq(project_statistics.sum(:lfs_objects_size))
      expect(root_statistics.build_artifacts_size).to eq(project_statistics.sum(:build_artifacts_size))
      expect(root_statistics.packages_size).to eq(project_statistics.sum(:packages_size))
      expect(root_statistics.wiki_size).to eq(project_statistics.sum(:wiki_size))
    end
  end
end
