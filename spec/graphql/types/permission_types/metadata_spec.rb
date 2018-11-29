# frozen_string_literal: true

require 'spec_helper'

describe Types::PermissionTypes::Metadata do
  it 'has required fields' do
    expect(described_class).to have_graphql_fields([:logIn])
  end
end
