# frozen_string_literal: true

module Resolvers
  class MetadataResolver < BaseResolver
    type Types::MetadataType, null: false

    def resolve
      { version: Gitlab::VERSION, revision: Gitlab.revision }
    end
  end
end
