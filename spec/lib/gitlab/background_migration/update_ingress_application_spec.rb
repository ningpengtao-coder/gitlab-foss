# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::BackgroundMigration::UpdateIngressApplication, :migration, schema: 20190325093036 do
  let(:background_migration) { described_class.new }

  let(:projects) { table(:projects) }
  let(:clusters) { table(:clusters) }
  let(:cluster_projects) { table(:cluster_projects) }
  let(:ingress) { table(:clusters_applications_ingress) }
  let(:namespaces) { table(:namespaces) }
  let(:namespace) { namespaces.create!(id: 1, name: 'gitlab', path: 'gitlab') }

  describe '#perform' do
    around do |example|
      Timecop.freeze { example.run }
    end

    let(:app_name) { 'ingress' }
    let(:now) { Time.now }

    let!(:project1) { create_project }
    let!(:project2) { create_project }
    let!(:cluster1) { create_cluster(project: project1) }
    let!(:cluster2) { create_cluster(project: project2) }
    let!(:ingress1) { create_ingress(cluster: cluster1) }
    let!(:ingress2) { create_ingress(cluster: cluster2) }

    it 'schedules ingress updates' do
      expect(ClusterUpgradeAppWorker)
        .to receive(:perform_async)
        .with(app_name, ingress1.id)
      expect(ClusterUpgradeAppWorker)
        .to receive(:perform_async)
        .with(app_name, ingress2.id)

      background_migration.perform(ingress1.id, ingress2.id)
    end
  end

  private

  def create_project
    projects.create!(namespace_id: namespace.id)
  end

  def create_cluster(project:)
    cluster = clusters.create!(name: 'cluster')
    cluster_projects.create!(cluster_id: cluster.id, project_id: project.id)
    cluster
  end

  def create_ingress(cluster:)
    ingress.create!(
      cluster_id: cluster.id,
      status: 3,
      version: '1.1.2',
      ingress_type: 1
    )
  end
end
