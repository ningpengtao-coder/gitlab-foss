# frozen_string_literal: true

# See http://doc.gitlab.com/ce/development/migration_style_guide.html
# for more information on how to write migrations for GitLab.

class IndexClustersKubernetesNamespacesOnClusterIdAndEnvironmentId < ActiveRecord::Migration[5.1]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false
  INDEX_NAME = 'index_clusters_kubernetes_namespaces_on_cluster_and_environment'

  disable_ddl_transaction!

  def up
    add_concurrent_index :clusters_kubernetes_namespaces, [:cluster_id, :environment_id],
      unique: true, name: INDEX_NAME
  end

  def down
    remove_concurrent_index :clusters_kubernetes_namespaces, name: INDEX_NAME
  end
end
