require 'spec_helper'

describe 'Error Tracking', :js do
  let(:project) { create(:project) }
  let(:user) { create(:user) }

  before do
    project.add_maintainer(user)
    gitlab_sign_in(user)
  end

  context 'error tracking list' do
    before do
      visit project_error_tracking_trackings_path(project)
    end

    it 'sees an empty state when there is no errors' do
      # TODO
    end

    it 'sees an empty state when sentry is not configured' do
      # TODO
    end

    it 'sees a error tracking list' do
      # TODO
    end
  end
end
