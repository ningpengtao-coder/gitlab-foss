# frozen_string_literal: true

require "gitlab/cluster/lifecycle_events"

if Gitlab::Cluster::LifecycleEvents.in_clustered_puma?
  unless ENV['DISABLE_PUMA_WORKER_KILLER']
    require "gitlab/cluster/puma_worker_killer_initializer"

    Gitlab::Cluster::PumaWorkerKillerInitializer.start @config.options unless ENV['DISABLE_PUMA_WORKER_KILLER']
  end
end
