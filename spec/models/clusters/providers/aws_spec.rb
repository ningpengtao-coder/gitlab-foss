# frozen_string_literal: true

require 'spec_helper'

describe Clusters::Providers::Aws do
  it { is_expected.to belong_to(:cluster) }
  it { is_expected.to validate_presence_of(:region) }

  include_examples 'provider status', :cluster_provider_aws

  describe 'default_value_for' do
    let(:provider) { build(:cluster_provider_aws) }

    it "sets default values" do
      expect(provider.region).to eq('us-east-1')
      expect(provider.num_nodes).to eq(3)
      expect(provider.machine_type).to eq('m5.large')
    end
  end

  describe 'validation' do
    subject { provider.valid? }

    context ':aws_account_id' do
      let(:provider) { build(:cluster_provider_aws, aws_account_id: aws_account_id) }

      context 'length is shorter than 12' do
        let(:aws_account_id) { '1' * 11 }

        it { is_expected.to be_falsey }
      end

      context 'length is longer than 12' do
        let(:aws_account_id) { '1' * 13 }

        it { is_expected.to be_falsey }
      end

      context 'has invalid characters' do
        let(:aws_account_id) { '0123456789ab' }

        it { is_expected.to be_falsey }
      end

      context 'account ID is valid' do
        let(:aws_account_id) { '123456789012' }

        it { is_expected.to be_truthy }
      end

      context 'account ID is valid, but contains hypens' do
        let(:aws_account_id) { '1234-5678-9012' }

        it { is_expected.to be_truthy }

        it 'strips hyphens before validating' do
          is_expected.to be_truthy

          expect(provider.aws_account_id).to eq('123456789012')
        end
      end
    end

    context ':num_nodes' do
      let(:provider) { build(:cluster_provider_aws, num_nodes: num_nodes) }

      context 'contains non-digit characters' do
        let(:num_nodes) { 'A3' }

        it { is_expected.to be_falsey }
      end

      context 'is blank' do
        let(:num_nodes) { nil }

        it { is_expected.to be_falsey }
      end

      context 'is less than 1' do
        let(:num_nodes) { 0 }

        it { is_expected.to be_falsey }
      end

      context 'is a positive integer' do
        let(:num_nodes) { 3 }

        it { is_expected.to be_truthy }
      end
    end
  end

  describe '#nullify_credentials' do
    let(:provider) { create(:cluster_provider_aws, :scheduled) }

    subject { provider.nullify_credentials }

    before do
      expect(provider.access_key_id).to be_present
      expect(provider.secret_access_key).to be_present
    end

    it 'removes access_key_id and secret_access_key' do
      subject

      expect(provider.access_key_id).to be_nil
      expect(provider.secret_access_key).to be_nil
    end
  end
end
