# frozen_string_literal: true

module Types
  class MetadataType < ::Types::BaseObject
    graphql_name 'Metadata'

    expose_permissions Types::PermissionTypes::Metadata

    field :version, GraphQL::STRING_TYPE, null: false
    field :revision, GraphQL::STRING_TYPE, null: false
  end
end

require_dependency Rails.root.join('ee', 'app', 'graphql', 'types', 'ee', 'metadata_type')
Types::MetadataType.prepend(EE::Types::MetadataType)
