require 'spec_helper'
require Rails.root.join('db', 'migrate', '20190329100623_generate_acme_private_key.rb')

describe GenerateAcmePrivateKey, :migration do
  let(:migration) { described_class.new }
  let(:settings_table) { table(:application_settings) }

  describe 'up' do
    it 'generates acme private key and saves it in application settings' do
      setting = settings_table.create(acme_private_key: nil)

      migration.up

      setting.reload

      expect(setting.acme_private_key).to be_truthy

      expect(OpenSSL::PKey::RSA.new(setting.acme_private_key)).to be_truthy
    end
  end
end
