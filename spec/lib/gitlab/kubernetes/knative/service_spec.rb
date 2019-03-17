# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Kubernetes::Knative::Service do
  let(:name) { 'my-service' }
  let(:namespace) { 'my-namespace' }
  let(:image) { 'example.com/image' }
  let(:service) { described_class.new(name, namespace, image) }

  describe '#generate' do
    let(:metadata) do
      {
        name: 'my-service',
        namespace: 'my-namespace'
      }
    end

    let(:spec) do
      {
        runLatest: {
          configuration: {
            revisionTemplate: {
              spec: {
                container: { image: 'example.com/image' }
              }
            }
          }
        }
      }
    end

    let(:resource) { ::Kubeclient::Resource.new(metadata: metadata, spec: spec) }

    subject { service.generate }

    it 'builds a Kubeclient Resource' do
      is_expected.to eq(resource)
    end
  end
end
