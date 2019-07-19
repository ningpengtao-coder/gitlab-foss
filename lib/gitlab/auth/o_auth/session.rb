# frozen_string_literal: true

# :nocov:
module Gitlab
  module Auth
    module OAuth
      module Session
        def self.create(provider, ticket)
          Gitlab::Cache::Store.main.write("gitlab:#{provider}:#{ticket}", ticket, expires_in: Gitlab.config.omniauth.cas3.session_duration)
        end

        def self.destroy(provider, ticket)
          Gitlab::Cache::Store.main.delete("gitlab:#{provider}:#{ticket}")
        end

        def self.valid?(provider, ticket)
          Gitlab::Cache::Store.main.read("gitlab:#{provider}:#{ticket}").present?
        end
      end
    end
  end
end
# :nocov:
