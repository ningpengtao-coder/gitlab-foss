# frozen_string_literal: true

require 'spec_helper'

describe Namespaces::AggregationSchedulerWorker, '#perform' do
  let(:group) { create(:group) }

  subject(:worker) { described_class.new }

  context 'when aggregation schedule exists' do
    it 'does not create a new one' do
      group.create_aggregation_schedule!

      expect do
        worker.perform(group.id)
      end.not_to change(Namespace::AggregationSchedule, :count)
    end
  end

  context 'when aggregation schedule does not exist' do
    it 'creates one' do
      allow_any_instance_of(Namespace::AggregationSchedule)
        .to receive(:schedule_root_storage_statistics).and_return(nil)

      expect do
        worker.perform(group.id)
      end.to change(Namespace::AggregationSchedule, :count).by(1)
    end
  end
end
