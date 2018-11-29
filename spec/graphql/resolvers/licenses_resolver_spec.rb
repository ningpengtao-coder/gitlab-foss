# frozen_string_literal: true

require 'spec_helper'

describe Resolvers::LicensesResolver do
  include GraphqlHelpers

  let(:license) { License.last }

  describe '#resolve' do
    it 'returns a collection of licenses sorted by asc id by default' do
      expect(resolve_licenses).to contain_exactly(*License.all.order_by('id_asc'))
    end

    it 'returns a collection of licenses sorted by a provided order_by string' do
      expect(resolve_licenses('id_desc')).to contain_exactly(*License.all.order_by('id_asc'))
    end

    it 'returns an array if no licenses exist' do
      License.delete_all

      expect(resolve_licenses).to eq([])
    end
  end

  def resolve_licenses(sort = nil)
    resolve(described_class, args: { sort: sort })
  end
end
