# frozen_string_literal: true

require 'spec_helper'

describe BackgroundCounterWorker do
  let(:worker) { described_class.new }
  let(:counter_service ) { BatchCount::ProjectsBatchCountService }
  let(:service) { double('batch count service', recalculate!: nil) }

  describe '#perform' do
    subject { worker.perform(counter_service.to_s) }

    it 'triggers a recalculate on the batch count service' do
      allow(counter_service).to receive(:new).and_return(service)

      expect(service).to receive(:recalculate!)

      subject
    end
  end
end
