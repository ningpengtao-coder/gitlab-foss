# frozen_string_literal: true

require 'spec_helper'

shared_examples 'base stage' do
  ISSUES_MEDIAN = 30.minutes.to_i

  let(:stage) { described_class.new(options: { project: double }) }

  before do
    allow(stage).to receive(:project_median).and_return(1.12)
    allow_any_instance_of(Gitlab::CycleAnalytics::BaseEventFetcher).to receive(:event_result).and_return({})
  end

  it 'has the median data value' do
    expect(stage.as_json[:value]).not_to be_nil
  end

  it 'has the median data stage' do
    expect(stage.as_json[:title]).not_to be_nil
  end

  it 'has the median data description' do
    expect(stage.as_json[:description]).not_to be_nil
  end

  it 'has the title' do
    expect(stage.title).to eq(stage_name.to_s.capitalize)
  end

  it 'has the events' do
    expect(stage.events).not_to be_nil
  end
end

shared_examples 'using Gitlab::CycleAnalytics::DataCollector as backend' do
  let(:stage_params) { Gitlab::CycleAnalytics::DefaultStages.send("params_for_#{stage_name}_stage").merge(project: project) }
  let(:stage) { CycleAnalytics::ProjectStage.new(stage_params) }
  let(:data_collector) { Gitlab::CycleAnalytics::DataCollector.new(stage, from: from, current_user: project.creator) }

  it 'provides the same median value' do
    expect(data_collector.median.seconds).to eq(ISSUES_MEDIAN)
  end

  it 'provides the same event records' do
    records = data_collector.records_fetcher.serialized_records
    expect(records.count).to eq(expected_record_count)
    expect(records.map { |event| event[:title] }).to eq(expected_record_titles)
  end
end
