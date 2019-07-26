# frozen_string_literal: true

require 'spec_helper'

describe BatchCount::ProjectsBatchCountWorker do
  include ExclusiveLeaseHelpers

  subject { described_class.new.perform }

  it 'creates the BackgroundCounter if it doesnt exist yet' do
    subject

    expect(BackgroundCounter.find_by(identifier: described_class::IDENTIFIER)).to be_present
  end

  context 'with an existing counter' do
    let!(:counter) { create(:background_counter, identifier: described_class::IDENTIFIER, counter_value: 0) }
    let(:counter_value) { 42 }

    it 'performs a batched count and updates the counter' do
      allow(Gitlab::Database::Count).to receive(:batched_count).with(Project.all).and_return(counter_value)

      expect { subject }.to change { counter.reload.counter_value }.from(0).to(counter_value)
    end

    it 'is guarded with an exclusive lease' do
      stub_exclusive_lease_taken(described_class.new.lease_key)

      expect(Gitlab::Database::Count).not_to receive(:batched_count)

      subject
    end
  end
end
