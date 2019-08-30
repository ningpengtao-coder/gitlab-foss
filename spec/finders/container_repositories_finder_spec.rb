# frozen_string_literal: true

require 'spec_helper'

describe ContainerRepositoriesFinder do
  set(:reporter) { create(:user) }
  set(:guest) { create(:user) }

  let(:group) { create(:group) }
  let(:project) { create(:project, group: group) }
  let(:project_repository) { create(:container_repository, project: project) }

  before do
    group.add_reporter(reporter)
    project.add_reporter(reporter)
  end

  describe '#execute' do
    context 'with authorized user' do
      subject { described_class.new(user: reporter, subject: subject_object).execute }

      context 'when container_type is group' do
        let(:subject_object) { group }
        let(:other_project) { create(:project, group: group) }

        let(:other_repository) do
          create(:container_repository, name: 'test_repository2', project: other_project)
        end

        it { is_expected.to match_array([project_repository, other_repository]) }
      end

      context 'when container_type is project' do
        let(:subject_object) { project }

        it { is_expected.to match_array([project_repository]) }
      end
    end

    context 'with unauthorized user' do
      subject { described_class.new(user: guest, subject: group).execute }

      it { is_expected.to be nil }
    end

    context 'with invalid subject' do
      let(:obj) { create(:user) }

      subject { described_class.new(user: reporter, subject: obj).execute }

      it { is_expected.to be nil }
    end
  end
end
