# frozen_string_literal: true

require 'rails_helper'

describe Gitlab::CycleAnalytics::RecordsFetcher do
  around do |example|
    Timecop.freeze { example.run }
  end

  it "respect issue visibility rules, confidential issues won't be listed" do
    project = create(:project, :empty_repo)
    user = create(:user)

    project.add_user(user, Gitlab::Access::GUEST)

    issue1 = create(:issue, project: project)
    issue2 = create(:issue, project: project, confidential: true)

    issue1.metrics.update(first_added_to_board_at: 3.days.ago)
    issue2.metrics.update(first_added_to_board_at: 3.days.ago)

    issue1.metrics.update!(first_mentioned_in_commit_at: 2.days.ago)
    issue2.metrics.update!(first_mentioned_in_commit_at: 2.days.ago)

    stage = build(:cycle_analytics_project_stage, {
      start_event_identifier: :plan_stage_start,
      end_event_identifier: :issue_first_mentioned_in_commit,
      project: project
    })

    data_collector = Gitlab::CycleAnalytics::DataCollector.new(stage, {
      from: Time.new(2019),
      current_user: user
    })

    expect(data_collector.records_fetcher.serialized_records.size).to eq(1)
  end
end
