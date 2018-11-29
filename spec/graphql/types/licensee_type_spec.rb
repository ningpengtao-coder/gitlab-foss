# frozen_string_literal: true

require 'spec_helper'

describe GitlabSchema.types['Licensee'] do
  it 'has required fields' do
    is_expected.to have_graphql_field(:name, :email, :company)
  end
end
