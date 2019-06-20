# frozen_string_literal: true

require 'rake_helper'

describe 'rake gitlab:pages:make_all_public' do
  let!(:old_project_with_public_pages) { create(:project, :pages_public) }
  let!(:project_for_update) { create(:project, :pages_enabled) }
  let!(:public_project) { create(:project, :public)}

  let(:migration_name) { 'MakePagesSitesPublic' }

  before do
    Rake.application.rake_require 'tasks/gitlab/pages'
  end

  subject do
    run_rake_task('gitlab:pages:make_all_public')
  end

  it 'schedules background migrations' do
    Sidekiq::Testing.fake! do
      Timecop.freeze do
        subject

        first_id = project_for_update.project_feature.id
        last_id = public_project.project_feature.id

        expect(migration_name).to be_scheduled_delayed_migration(2.minutes, first_id, last_id)
      end
    end
  end

  it 'updates settings' do
    perform_enqueued_jobs do
      expect do
        subject
      end.to change { project_for_update.reload.project_feature.pages_access_level }.from(ProjectFeature::ENABLED).to(ProjectFeature::PUBLIC)
    end
  end

  it 'skips public projects' do
    perform_enqueued_jobs do
      expect do
        subject
      end.not_to change { public_project.reload.project_feature.pages_access_level }.from(ProjectFeature::ENABLED)
    end
  end
end
