# frozen_string_literal: true

# See http://doc.gitlab.com/ce/development/migration_style_guide.html
# for more information on how to write migrations for GitLab.

class AddAuthorToDesignManagementVersions < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  disable_ddl_transaction!

  # Set this constant to true if this migration requires downtime.
  DOWNTIME = false

  def change
    add_reference :design_management_versions, :author, index: true
    add_concurrent_foreign_key :design_management_versions, :users, column: :author_id
  end
end
