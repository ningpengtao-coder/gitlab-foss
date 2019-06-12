# frozen_string_literal: true

require 'spec_helper'

describe Namespaces::PruneAggregationSchedulesWorker, '#perform' do
  subject(:worker) { described_class.new }

  before do
    allow_any_instance_of(Namespace::AggregationSchedule)
      .to receive(:schedule_root_storage_statistics).and_return(nil)
  end

  context 'with pending aggregation schedules' do
    before do
      create_list(:namespace, 5, :with_aggregation_schedule)
    end

    it 'schedules a worker per pending aggregation' do
      expect(Namespaces::RootStatisticsWorker)
        .to receive(:perform_in).exactly(5).times

      worker.perform
    end
  end

  context 'without pending aggregation schedules' do
    it 'does not schedules a worker' do
      expect(Namespaces::RootStatisticsWorker)
        .not_to receive(:perform)

      worker.perform
    end
  end
end
