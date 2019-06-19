# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Ci::Build::Prerequisite::Factory do
  let(:build) { instance_double(Ci::Build) }

  describe '.prerequisites' do
    it 'returns KubernetesNamespace and Deployment' do
      expect(described_class.prerequisites).to contain_exactly(
        Gitlab::Ci::Build::Prerequisite::KubernetesNamespace,
        Gitlab::Ci::Build::Prerequisite::Deployment
      )
    end
  end

  describe '#unmet' do
    let(:kubernetes_namespace) do
      instance_double(
        Gitlab::Ci::Build::Prerequisite::KubernetesNamespace,
        unmet?: true)
    end

    let(:deployment) do
      instance_double(
        Gitlab::Ci::Build::Prerequisite::Deployment,
        unmet?: false)
    end

    it 'returns only unmet prerequisites' do
      expect(Gitlab::Ci::Build::Prerequisite::KubernetesNamespace)
        .to receive(:new).with(build).and_return(kubernetes_namespace)
      expect(Gitlab::Ci::Build::Prerequisite::Deployment)
        .to receive(:new).with(build).and_return(deployment)

      unmet = described_class.new(build).unmet

      expect(unmet).to contain_exactly(kubernetes_namespace)
    end
  end
end
