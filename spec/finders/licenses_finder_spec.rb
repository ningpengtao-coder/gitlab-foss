# frozen_string_literal: true

require 'spec_helper'

describe LicensesFinder do
  let(:license) { License.last }

  it 'returns a license by id' do
    expect(described_class.new(id: license[:id]).execute.take).to eq(license)
  end

  it 'returns a sorted collection of licenses' do
    expect(described_class.new(sort: 'id_desc').execute).to contain_exactly(*License.all.order_by('id_desc'))
  end

  it 'returns empty relation if the license doesnt exist' do
    expect(described_class.new(id: license[:id] + 1).execute).to be_empty
  end
end
