# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Namespace::AggregationSchedule, type: :model do
  it { is_expected.to belong_to :namespace }

  describe '#schedule_root_storage_statistics' do
    it 'schedules a root storage statistics after create' do
      aggregation_schedule = build(:namespace_aggregation_schedules)

      expect(Namespaces::RootStatisticsWorker)
        .to receive(:perform_in).once

      aggregation_schedule.save!
    end
  end
end
