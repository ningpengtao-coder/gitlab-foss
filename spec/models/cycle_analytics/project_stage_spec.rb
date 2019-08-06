# frozen_string_literal: true

require 'rails_helper'

describe CycleAnalytics::ProjectStage do
  it 'default stages must be valid' do
    project = create(:project)

    Gitlab::CycleAnalytics::DefaultStages.all.each do |params|
      stage = described_class.new(params.merge(project: project))
      expect(stage).to be_valid
    end
  end

  it_behaves_like "cycle analytics stage" do
    let(:parent) { create(:project) }
  end
end
