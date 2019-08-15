# frozen_string_literal: true

class AddCloudRunToCluster < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  # Set this constant to true if this migration requires downtime.
  DOWNTIME = false

  disable_ddl_transaction!

  def up
    add_column_with_default(:clusters, :cloud_run, :boolean, default: false)
  end

  def down
    remove_column(:clusters, :cloud_run)
  end
end
