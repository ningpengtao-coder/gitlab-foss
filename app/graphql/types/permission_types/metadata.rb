# frozen_string_literal: true

module Types
  module PermissionTypes
    class Metadata < BasePermissionType
      graphql_name 'MetadataPermissions'
      abilities :log_in
    end
  end
end
