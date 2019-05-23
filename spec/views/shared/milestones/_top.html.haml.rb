require 'spec_helper'

describe 'shared/milestones/_top.html.haml' do
  set(:group) { create(:group) }
  let(:project) { create(:project, group: group) }
  let(:milestone) { create(:milestone, project: project) }

  before do
    allow(milestone).to receive(:milestones) { [] }
  end

  it 'does not render a deprecation message for a non-legacy and non-dashboard milestone' do
    assign :group, group

    render 'shared/milestones/top', milestone: milestone

    expect(rendered).not_to have_css('.milestone-deprecation-message')
  end
end
