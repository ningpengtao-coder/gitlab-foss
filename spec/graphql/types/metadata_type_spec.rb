# frozen_string_literal: true

require 'spec_helper'

describe GitlabSchema.types['Metadata'] do
  context 'license' do
    subject { described_class.fields['license'] }

    it 'has required arguments, type and resolver' do
      is_expected.to have_graphql_arguments(:id)
      is_expected.to have_graphql_type(Types::LicenseType)
      is_expected.to have_graphql_resolver(Resolvers::LicenseResolver)
    end

    it 'authorizes with read_license' do
      is_expected.to require_graphql_authorizations(:read_license)
    end
  end

  context 'licenses' do
    subject { described_class.fields['licenses'] }

    it 'has required arguments, type and resolver' do
      is_expected.to have_graphql_arguments(:sort, :after, :before, :first, :last)
      is_expected.to have_graphql_connection_type(Types::LicenseType)
      is_expected.to have_graphql_resolver(Resolvers::LicensesResolver)
    end
  end
end
