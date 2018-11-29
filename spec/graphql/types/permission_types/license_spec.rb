# frozen_string_literal: true

require 'spec_helper'

describe Types::PermissionTypes::License do
  it 'has required fields' do
    expect(described_class).to have_graphql_fields([:read_license, :update_license])
  end
end
