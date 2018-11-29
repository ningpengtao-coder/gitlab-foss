# frozen_string_literal: true

require 'spec_helper'

describe 'License' do
  include GraphqlHelpers

  set(:license) { create(:license, data: build(:gitlab_license, restrictions: { active_user_count: 10 }, licensee: { Email: 'test@gitlab.com', Name: 'Test User', Company: 'GitLab' }).export) }
  set(:license_two) { create(:license, data: build(:gitlab_license, restrictions: { active_user_count: 10 }, licensee: { Email: 'test@gitlab.com', Name: 'Test User', Company: 'GitLab' }).export) }
  set(:current_user) { create(:admin) }

  let(:query) do
    graphql_query_for('metadata', {}, query_graphql_field('license', { id: license[:id] }))
  end

  it_behaves_like 'a working graphql query' do
    before do
      post_graphql(query, current_user: current_user)
    end
  end

  context 'licenses collection' do
    let(:query) do
      fields = <<~FIELDS
      edges {
        node {
          #{all_graphql_fields_for('license'.classify)}
        }
      }
      FIELDS
      graphql_query_for('metadata', {}, query_graphql_field('licenses', { after: '', first: 2, sort: :id_desc }, fields))
    end

    it_behaves_like 'a working graphql query' do
      before do
        post_graphql(query, current_user: current_user)
      end
    end
  end
end
