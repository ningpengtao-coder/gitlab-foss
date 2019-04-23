# frozen_string_literal: true

require 'spec_helper'
require Rails.root.join('db', 'post_migrate', '20190423143911_enqueue_ingress_updates.rb')

describe EnqueueIngressUpdates, :migration, :sidekiq do
  let(:migration) { described_class.new }
  let(:background_migration) { described_class::MIGRATION }
  let(:batch_size_constant) { "#{described_class}::BATCH_SIZE" }
  let(:delay) { described_class::DELAY_INTERVAL }

  let(:clusters) { table(:clusters) }
  let(:ingress) { table(:clusters_applications_ingress) }

  describe '#up' do
    around do |example|
      Sidekiq::Testing.fake! do
        Timecop.freeze do
          example.run
        end
      end
    end

    before do
      stub_const(batch_size_constant, 2)
    end

    context 'with ingress applications' do
      let!(:ingress1) { create_ingress }
      let!(:ingress2) { create_ingress }
      let!(:ingress3) { create_ingress }

      it 'schedules update jobs' do
        migration.up

        expect(BackgroundMigrationWorker.jobs.size).to eq(2)
        expect(background_migration)
          .to be_scheduled_delayed_migration(delay, ingress1.id, ingress2.id)
        expect(background_migration)
          .to be_scheduled_delayed_migration(delay * 2, ingress3.id, ingress3.id)
      end
    end

    context 'without ingress applications' do
      it 'does not schedule update jobs' do
        migration.up

        expect(BackgroundMigrationWorker.jobs.size).to eq(0)
      end
    end

    private

    def create_ingress
      cluster = clusters.create!(name: 'cluster')

      ingress.create!(
        cluster_id: cluster.id,
        status: 3,
        version: '1.2.3',
        ingress_type: 1
      )
    end
  end
end
