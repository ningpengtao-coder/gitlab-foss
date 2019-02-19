# frozen_string_literal: true

class AddForkingAccessLevelToProjects < ActiveRecord::Migration[5.0]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  disable_ddl_transaction!

  def up
    add_column :projects, :forking_access_level, :integer
  end

  def down
    remove_column :projects, :forking_access_level
  end
end
