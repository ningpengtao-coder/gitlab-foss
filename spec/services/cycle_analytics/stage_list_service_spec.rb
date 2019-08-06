# frozen_string_literal: true

require 'spec_helper'

describe CycleAnalytics::StageListService do
  let(:project) { build(:project, :empty_repo) }

  it 'returns the default stages as in-memory objects if customizable stages are not allowed' do
    service = described_class.new(parent: project, allowed_to_customize_stages: false)

    stages = service.execute

    stage_names = stages.map(&:name)
    expect(stage_names).to eq(Gitlab::CycleAnalytics::DefaultStages.all.map { |p| p[:name] })

    stage_ids = stages.map(&:id)
    expect(stage_ids.all?(&:nil?)).to eq(true)
  end
end
