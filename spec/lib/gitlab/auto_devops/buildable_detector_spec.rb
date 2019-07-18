# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::AutoDevops::BuildableDetector do
  describe '#buildable?' do
    let(:project) { create(:project) }
    let(:ref) { :head }

    subject(:detector) { described_class.new(project, ref) }

    context 'no matching variables or files' do
      it 'is not buildable' do
        expect(detector).to_not be_buildable
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
      let(:project) { create(:project, :custom_repo, files: { 'Dockerfile' => '' }) }

      it 'is buildable' do
        expect(detector).to be_buildable
      end
    end
  end
end
