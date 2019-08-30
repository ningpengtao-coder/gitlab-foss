# frozen_string_literal: true

require 'spec_helper'
require Rails.root.join('db', 'post_migrate', '20190829131947_backfill_release_name_with_tag.rb')

describe BackfillReleaseNameWithTag, :migration do
  let(:releases)   { table(:releases) }
  let(:namespaces) { table(:namespaces) }
  let(:projects)   { table(:projects) }

  let(:namespace)  { namespaces.create(name: 'foo', path: 'foo') }
  let(:project)    { projects.create!(namespace_id: namespace.id, visibility_level: Gitlab::VisibilityLevel::PUBLIC) }
  let!(:release)   { releases.create!(project_id: project.id, name: nil, tag: 'v1.0.0', released_at: 2.days.ago) }

  it 'defaults name to tag value' do
    expect(release.tag).to be_present

    migrate!

    release.reload
    expect(release.name).to eq(release.tag)
  end
end
