# frozen_string_literal: true

require 'spec_helper'

describe GitlabSchema.types['License'] do
  it 'has license permission type' do
    expect(described_class).to expose_permissions_using(Types::PermissionTypes::License)
  end

  it 'has required fields' do
    required_fields = [
     :id,
     :plan,
     :expired,
     :created_at,
     :starts_at,
     :expires_at,
     :current_active_users_count,
     :restricted_user_count,
     :historical_max,
     :overage,
     :licensee
    ]

    is_expected.to have_graphql_field(*required_fields)
  end

  it 'has a non-null LicenseeType field' do
    expect(described_class.fields["licensee"]).to have_graphql_type(Types::LicenseeType.to_non_null_type)
  end
end
