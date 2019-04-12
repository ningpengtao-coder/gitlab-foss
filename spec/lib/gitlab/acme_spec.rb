# frozen_string_literal: true

require 'spec_helper'

describe Gitlab::Acme do
  include AcmeHelpers

  before do
    #WebMock.allow_net_connect!
    stub_directory
  end

  describe '#create' do
    subject { described_class.client }

    context 'when admin email is set' do
      let!(:application_setting) { create(:application_setting, acme_notification_email: 'info@test.example.com', acme_terms_of_service_accepted: true, acme_private_key: OpenSSL::PKey::RSA.new(4096).to_s) }

      context 'when account is not yet created' do
        it 'creates new account' do

          subject
        end
      end

      context 'when account is already created' do
        it 'returns Acme client' do
          expect(subject).to be_a(Acme::Client)
        end
      end
    end

    context 'when admin email is not set' do
      it 'raises an exeption' do
        expect { subject }.to raise_error('Acme integration is disabled')
      end
    end
  end
end
