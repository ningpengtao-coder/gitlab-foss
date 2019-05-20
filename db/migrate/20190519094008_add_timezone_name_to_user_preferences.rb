# frozen_string_literal: true

# See http://doc.gitlab.com/ce/development/migration_style_guide.html
# for more information on how to write migrations for GitLab.

class AddTimezoneNameToUserPreferences < ActiveRecord::Migration[5.1]
  include Gitlab::Database::MigrationHelpers

  disable_ddl_transaction!

  DOWNTIME = false

  def up
    add_column(:user_preferences, :timezone_name, :string)
  end

  def down
    remove_column(:user_preferences, :timezone_name)
  end
end
