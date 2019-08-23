# frozen_string_literal: true

# See http://doc.gitlab.com/ce/development/migration_style_guide.html
# for more information on how to write migrations for GitLab.

class CreateClusterProvidersAws < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def change
    create_table :cluster_providers_aws do |t|
      t.references :cluster, null: false, type: :bigint, index: { unique: true }, foreign_key: { on_delete: :cascade }

      t.integer :status, null: false
      t.text :status_reason

      t.string :aws_account_id, null: false, limit: 12
      t.string :region, null: false, limit: 64
      t.integer :num_nodes, null: false
      t.string :machine_type, null: false, limit: 64

      t.string :access_key_id, limit: 64
      t.text :encrypted_secret_access_key
      t.string :encrypted_secret_access_key_iv, limit: 255

      t.timestamps_with_timezone null: false

      t.index [:cluster_id, :status]
    end
  end
end
