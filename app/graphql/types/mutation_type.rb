# frozen_string_literal: true

module Types
  class MutationType < BaseObject
    include Gitlab::Graphql::MountMutation

    graphql_name "Mutation"

    mount_mutation Mutations::MergeRequests::SetWip
  end
end

require_dependency Rails.root.join('ee', 'app', 'graphql', 'types', 'ee', 'mutation_type')
Types::MutationType.prepend(EE::Types::MutationType)
