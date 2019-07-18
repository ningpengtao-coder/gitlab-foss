# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Ci::Build::Prerequisite::AutoDevopsBuildable do
  let(:project) { create(:project) }
  let(:pipeline) { create(:ci_pipeline, :auto_devops_source, project: project) }
  let(:build) { create(:ci_build, pipeline: pipeline, project: project) }

  subject { described_class.new(build) }

  before do
    stub_application_setting(auto_devops_enabled: true)
  end

  describe '#unmet?' do
    context 'when auto-devops is implicitly enabled and pipeline is not flagged' do
      it 'matches' do
        expect(subject).to be_unmet
      end
    end

    context 'when auto-devops is disabled' do
      let(:project) { create(:project, :auto_devops_disabled) }

      it 'does not match' do
        expect(subject).not_to be_unmet
      end
    end

    context 'when pipeline is already flagged' do
      let(:pipeline) { create(:ci_pipeline, project: project, auto_devops_buildable: true) }

      it 'does not match' do
        expect(subject).not_to be_unmet
      end
    end

    context 'when pipeline is not an auto-devops source' do
      let(:pipeline) { create(:ci_pipeline, :repository_source, project: project) }

      it 'does not match' do
        expect(subject).not_to be_unmet
      end
    end

    context 'when auto-devops is explicitly enabled' do
      let(:project) { create(:project, :auto_devops) }

      it 'does not match' do
        expect(subject).not_to be_unmet
      end
    end
  end

  describe 'complete!' do
    context 'buildable' do
      before do
        expect_next_instance_of(Gitlab::AutoDevops::BuildableDetector) do |detector|
          expect(detector).to receive(:buildable?).and_return(true)
        end
      end

      it 'sets flag based on buildable detector' do
        subject.complete!

        expect(pipeline.auto_devops_buildable).to be true
      end
    end

    context 'not buildable' do
      before do
        expect_next_instance_of(Gitlab::AutoDevops::BuildableDetector) do |detector|
          expect(detector).to receive(:buildable?).and_return(false)
        end
      end

      it 'sets flag based on buildable detector' do
        expect { subject.complete! }.to throw_symbol(:unsupported)
        expect(pipeline.auto_devops_buildable).to be false
      end
    end
  end
end
