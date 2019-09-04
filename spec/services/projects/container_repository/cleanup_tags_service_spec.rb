# frozen_string_literal: true

require 'spec_helper'

describe Projects::ContainerRepository::CleanupTagsService do
  set(:user) { create(:user) }
  set(:project) { create(:project, :private) }
  set(:repository) { create(:container_repository, :root, project: project) }

  let(:service) { described_class.new(project, user, params) }

  before do
    project.add_maintainer(user)

    stub_feature_flags(container_registry_cleanup: true)

    stub_container_registry_config(enabled: true)

    stub_container_registry_tags(
      repository: repository.path,
      tags: %w(latest A Ba Bb C D E))

    stub_tag_digest('latest', 'sha256:configA')
    stub_tag_digest('A', 'sha256:configA')
    stub_tag_digest('Ba', 'sha256:configB')
    stub_tag_digest('Bb', 'sha256:configB')
    stub_tag_digest('C', 'sha256:configC')
    stub_tag_digest('D', 'sha256:configD')
    stub_tag_digest('E', nil)

    stub_digest_config('sha256:configA', 1.hour.ago)
    stub_digest_config('sha256:configB', 5.days.ago)
    stub_digest_config('sha256:configC', 1.month.ago)
    stub_digest_config('sha256:configD', nil)
  end

  describe '#execute' do
    subject { service.execute(repository) }

    context 'when no params are specified' do
      let(:params) { {} }

      it 'does not remove anything' do
        expect_any_instance_of(ContainerRegistry::Client).not_to receive(:delete_repository_tag)

        is_expected.to include(status: :success, deleted: [])
      end
    end

    context 'when regex matching everything is specified' do
      let(:params) do
        { 'name_regex' => '.*' }
      end

      it 'does remove A, B* and C' do
        # The :E cannot be removed as it does not have valid manifest

        expect_delete_tag('sha256:configA')
        expect_delete_image('sha256:configB')
        expect_delete_image('sha256:configC')
        expect_delete_image('sha256:configD')

        is_expected.to include(status: :success, deleted: %w(D A Bb Ba C))
      end
    end

    context 'when regex matching specific tags is used' do
      let(:params) do
        { 'name_regex' => 'C|D' }
      end

      it 'does remove C and D' do
        expect_delete_image('sha256:configC')
        expect_delete_image('sha256:configD')

        is_expected.to include(status: :success, deleted: %w(D C))
      end
    end

    context 'when removing a tagged image that is used by another tag' do
      let(:params) do
        { 'name_regex' => 'Ba' }
      end

      it 'DOES remove the tag' do
        expect_delete_tag('sha256:configB')

        is_expected.to include(status: :success, deleted: %w(Ba))
      end
    end

    context 'when removing keeping only 3' do
      let(:params) do
        { 'name_regex' => '.*',
          'keep_n' => 3 }
      end

      it 'does remove C as it is oldest' do
        expect_delete_tag('sha256:configB')
        expect_delete_image('sha256:configC')

        is_expected.to include(status: :success, deleted: %w(Ba C))
      end
    end

    context 'when removing older than 1 day' do
      let(:params) do
        { 'name_regex' => '.*',
          'older_than' => '1 day' }
      end

      it 'does remove B* and C as they are older than 1 day' do
        expect_delete_image('sha256:configB')
        expect_delete_image('sha256:configC')

        is_expected.to include(status: :success, deleted: %w(Bb Ba C))
      end
    end

    context 'when combining all parameters' do
      let(:params) do
        { 'name_regex' => '.*',
          'keep_n' => 1,
          'older_than' => '1 day' }
      end

      it 'does remove B* and C' do
        expect_delete_image('sha256:configB')
        expect_delete_image('sha256:configC')

        is_expected.to include(status: :success, deleted: %w(Bb Ba C))
      end
    end

    context 'as a developer' do
      let(:developer) { create(:user) }
      let(:service) { described_class.new(project, developer, params) }

      before do
        project.add_developer(developer)
      end

      context 'using the names param' do
        let(:params) do
          { 'names' => ['C'] }
        end

        it 'can delete the tags by name' do
          expect_delete_image('sha256:configC')

          is_expected.to include(status: :success, deleted: %w(C))
        end
      end

      context 'using regex param' do
        let(:params) do
          { 'name_regex' => '.*' }
        end

        it 'cant delete the tags by regex' do
          is_expected.to include(status: :error, message: 'empty or missing names param')
        end
      end

      context 'with empty list of names' do
        let(:params) do
          { 'names' => [] }
        end

        it 'cant delete the tags by regex' do
          is_expected.to include(status: :error, message: 'empty or missing names param')
        end
      end
    end
  end

  private

  def stub_tag_digest(tag, digest)
    allow_any_instance_of(ContainerRegistry::Client)
      .to receive(:repository_tag_digest)
      .with(repository.path, tag) { digest }

    allow_any_instance_of(ContainerRegistry::Client)
      .to receive(:repository_manifest)
      .with(repository.path, tag) do
      { 'config' => { 'digest' => digest } } if digest
    end
  end

  def stub_digest_config(digest, created_at)
    allow_any_instance_of(ContainerRegistry::Client)
      .to receive(:blob)
      .with(repository.path, digest, nil) do
      { 'created' => created_at.to_datetime.rfc3339 }.to_json if created_at
    end
  end

  def expect_delete_tag(digest)
    expect_any_instance_of(ContainerRegistry::Client)
      .to receive(:put_dummy_tag)
      .with(repository.path, anything)

    expect_delete_image(digest)
  end

  def expect_delete_image(digest)
    expect_any_instance_of(ContainerRegistry::Client)
      .to receive(:delete_repository_tag)
      .with(repository.path, digest)
  end
end
