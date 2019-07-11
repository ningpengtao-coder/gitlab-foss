# frozen_string_literal: true

module Gitlab
  module Git
    module RuggedImpl
      module UseRugged
        def use_rugged?(repo, feature_key)
          return false
          feature = Feature.get(feature_key)
          return feature.enabled? if Feature.persisted?(feature)

          Gitlab::GitalyClient.can_use_disk?(repo.storage)
        end
      end
    end
  end
end
