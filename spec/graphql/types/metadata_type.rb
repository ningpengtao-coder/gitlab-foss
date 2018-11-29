# frozen_string_literal: true

require 'spec_helper'

describe GitlabSchema.types['Metadata'] do
  it 'is called Metadata' do
    expect(described_class.graphql_name).to eq('Metadata')
  end

  it 'has license permission type' do
    expect(described_class).to expose_permissions_using(Types::PermissionTypes::Metadata)
  end

  it 'has required queries' do
    is_expected.to have_graphql_field(:version)
    is_expected.to have_graphql_field(:revision)
  end
end
