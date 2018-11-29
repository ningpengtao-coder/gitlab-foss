# frozen_string_literal: true

require 'spec_helper'

describe 'Metadata' do
  include GraphqlHelpers

  set(:current_user) { create(:user) }
  let(:query) do
    fields = <<~FIELDS
      version
      revision
    FIELDS
    graphql_query_for('metadata', {}, fields)
  end

  it_behaves_like 'a working graphql query' do
    before do
      post_graphql(query, current_user: current_user)
    end
  end

  it 'returns version and revision' do
    post_graphql(query, current_user: current_user)

    expect(graphql_data['metadata']['version']).to eq(Gitlab::VERSION)
    expect(graphql_data['metadata']['revision']).to eq(Gitlab.revision)
  end
end
