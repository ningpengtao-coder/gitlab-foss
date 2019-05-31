# frozen_string_literal: true

# See http://doc.gitlab.com/ce/development/migration_style_guide.html
# for more information on how to write migrations for GitLab.

class RemoveRedundantClustersKubernetesNamespacesIndex < ActiveRecord::Migration[5.1]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  disable_ddl_transaction!

  def up
    remove_concurrent_index :clusters_kubernetes_namespaces, :cluster_id
  end

  def down
    add_concurrent_index :clusters_kubernetes_namespaces, :cluster_id
  end
end
