# frozen_string_literal: true

require 'spec_helper'

describe Mutations::Licenses::Delete do
  describe '#resolve' do
    set(:license) { create(:license) }

    it 'raises an error if the user cannot update the license' do
      mutation = described_class.new(object: nil, context: { current_user: create(:user) })
      expect { mutation.resolve(id: license[:id]) }.to raise_error(Gitlab::Graphql::Errors::ResourceNotAvailable)
    end

    describe 'when the user can update the license' do
      set(:user) { create(:admin) }
      subject(:mutation) { described_class.new(object: nil, context: { current_user: user }) }

      it 'returns the deleted license' do
        response = mutation.resolve(id: license[:id])
        expect(response[:license]).to eq(license)
        expect(License.where(id: license[:id])).not_to exist
        expect(response[:errors]).to be_empty
      end

      it 'returns an error when the license doesnt exist' do
        expect { mutation.resolve(id: license[:id] + 1) }.to raise_error(Gitlab::Graphql::Errors::ResourceNotAvailable)
      end
    end
  end
end
