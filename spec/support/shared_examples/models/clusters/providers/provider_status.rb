# frozen_string_literal: true

shared_examples 'provider status' do |factory|
  describe 'state_machine' do
    context 'when any => [:created]' do
      let(:provider) { build(factory, :creating) }

      it 'nullifies API credentials' do
        expect(provider).to receive(:nullify_credentials)
        provider.make_created

        expect(provider).to be_created
      end
    end

    context 'when any => [:creating]' do
      let(:provider) { build(factory) }
      let(:operation_id) { 'operation-xxx' }

      it 'sets operation_id' do
        expect(provider).to receive(:assign_operation_id).with(operation_id)

        provider.make_creating(operation_id)
      end
    end

    context 'when any => [:errored]' do
      let(:provider) { build(factory, :creating) }
      let(:status_reason) { 'err msg' }

      it 'removes access_token and operation_id' do
        expect(provider).to receive(:nullify_credentials)

        provider.make_errored(status_reason)

        expect(provider.status_reason).to eq(status_reason)
        expect(provider).to be_errored
      end

      context 'when status_reason is nil' do
        let(:provider) { build(factory, :errored) }

        it 'does not set status_reason' do
          provider.make_errored(nil)

          expect(provider.status_reason).not_to be_nil
        end
      end
    end
  end

  describe '#on_creation?' do
    subject { provider.on_creation? }

    context 'when status is creating' do
      let(:provider) { create(factory, :creating) }

      it { is_expected.to be_truthy }
    end

    context 'when status is created' do
      let(:provider) { create(factory, :created) }

      it { is_expected.to be_falsey }
    end
  end
end
