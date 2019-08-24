# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::BatchModelLoader do
  it 'optimises query access by batching', :request_cache do
    project_a_id = create(:project, title: 'a').id
    project_b_id = create(:project, title: 'b').id

    user_a_id = create(:user, username: 'user-a').id

    expect do
      project_a = described_class.for(Project).find(project_a_id)
      user_a = described_class.for(User).find(user_a_id)

      # force user-a
      expect(user_a.username).to eq('user-a')

      project_b = described_class.for(Project).find(project_b_id)

      # Force projects
      expect(project_a.title).to eq('a')
      expect(project_b.title).to eq('b')
    end.not_to exceed_query_limit(2)
  end
end
