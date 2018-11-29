# frozen_string_literal: true

require 'spec_helper'

describe Resolvers::LicenseResolver do
  include GraphqlHelpers

  let(:license) { License.last }

  describe '#resolve' do
    it 'returns an existing license found by id' do
      expect(resolve_license(license[:id])).to eq(license)
    end

    it 'returns nil if the license doesnt exist' do
      expect(resolve_license(license[:id] + 1)).to be_nil
    end
  end

  def resolve_license(id)
    resolve(described_class, args: { id: id })
  end
end
