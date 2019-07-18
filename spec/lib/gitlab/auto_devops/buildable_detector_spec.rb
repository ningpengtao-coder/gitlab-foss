# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::AutoDevops::BuildableDetector do
  describe '#buildable?' do
    let(:project) { create(:project) }
    let(:ref) { nil }

    subject(:detector) { described_class.new(project, ref) }

    context 'no matching variables or files' do
      it 'is not buildable' do
        expect(detector).not_to be_buildable
      end
    end

    context 'matching variable' do
      before do
        create(:ci_variable, project: project, key: 'BUILDPACK_URL')
      end

      it 'is buildable' do
        expect(detector).to be_buildable
      end
    end

    context 'matching file' do
      using RSpec::Parameterized::TableSyntax

      where(:filename, :buildable) do
        'unknownfile'                                      | false
        'Dockerfile'                                       | true
        'src/gitlab.com/gitlab-org/goproject/goproject.go' | true
      end

      with_them do
        let(:project) { create(:project, :custom_repo, files: { filename => '' }) }

        it 'detects buildable files' do
          if buildable
            expect(detector).to be_buildable
          else
            expect(detector).not_to be_buildable
          end
        end
      end
    end
  end
end
