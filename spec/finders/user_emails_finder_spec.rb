# frozen_string_literal: true

require 'spec_helper'

describe UserEmailsFinder do
  describe '#execute' do
    let(:user) { create(:user) }
    let!(:email1) { create(:email, user: user) }
    let!(:email2) { create(:email, user: user) }

    def slice_email_attributes(emails)
      emails.map { |email| email.slice('id', 'email') }.map(&:symbolize_keys)
    end

    it 'returns the primary email with nil id when types is primary' do
      emails = described_class.new(user.reload, types: %w[primary]).execute

      expect(slice_email_attributes(emails)).to eq([{ id: nil, email: user.email }])
    end

    it 'returns the secondary emails when types is secondary' do
      emails = described_class.new(user.reload, types: %w[secondary]).execute

      expect(slice_email_attributes(emails)).to eq([{ id: email1.id, email: email1.email },
                                                    { id: email2.id, email: email2.email }])
    end

    it 'returns both primary and secondary emails when type is primary,secondary sorted by id asc null first' do
      emails = described_class.new(user.reload, types: %w[primary secondary]).execute

      expect(slice_email_attributes(emails)).to eq([{ id: nil, email: user.email },
                                                    { id: email1.id, email: email1.email },
                                                    { id: email2.id, email: email2.email }])
    end

    it 'returns an empty relation when types is empty' do
      emails = described_class.new(user.reload, types: []).execute

      expect(emails).to be_empty
    end
  end
end
