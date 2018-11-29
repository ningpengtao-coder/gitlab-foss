# frozen_string_literal: true

require 'spec_helper'

describe 'Deleting an instance license' do
  include GraphqlHelpers

  set(:user) { create(:admin) }
  set(:license) { create(:license) }
  let(:mutation) do
    variables = {
      id: license[:id]
    }
    graphql_mutation(:license_delete, variables)
  end

  def mutation_response
    graphql_mutation_response(:license_delete)
  end

  it 'returns an error if the user is not allowed to update the license' do
    post_graphql_mutation(mutation, current_user: create(:user))

    expect(graphql_errors).not_to be_empty
  end

  it 'deletes the license' do
    post_graphql_mutation(mutation, current_user: user)

    expect(response).to have_gitlab_http_status(:success)
    expect(License.where(id: license[:id])).not_to exist
  end
end
