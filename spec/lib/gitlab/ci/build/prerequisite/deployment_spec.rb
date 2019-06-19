# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Ci::Build::Prerequisite::Deployment do
  describe '#unmet?' do
    context 'when the build starts an environment' do
      it 'returns true if there is no deployment' do
        build = instance_double(Ci::Build, starts_environment?: true, has_deployment?: false)
        prerequisite = described_class.new(build)

        expect(prerequisite).to be_unmet
      end

      it 'returns false if there is a deployment' do
        build = instance_double(Ci::Build, starts_environment?: true, has_deployment?: true)
        prerequisite = described_class.new(build)

        expect(prerequisite).not_to be_unmet
      end
    end

    it 'returns false if the build does not start an environment' do
      build = instance_double(Ci::Build, starts_environment?: false)
      prerequisite = described_class.new(build)

      expect(prerequisite).not_to be_unmet
    end
  end

  describe '#complete!' do
    context 'when prerequisite is unmet' do
      it 'creates a deployment and environment' do
        build = instance_double(Ci::Build, starts_environment?: true, has_deployment?: false)
        prerequisite = described_class.new(build)

        expect(build).to receive(:create_deployment)

        prerequisite.complete!
      end
    end

    context 'when prerequisite is met' do
      it 'creates a deployment and environment' do
        build = instance_double(Ci::Build, starts_environment?: true, has_deployment?: true)
        prerequisite = described_class.new(build)

        expect(build).not_to receive(:create_deployment)

        prerequisite.complete!
      end
    end
  end
end
