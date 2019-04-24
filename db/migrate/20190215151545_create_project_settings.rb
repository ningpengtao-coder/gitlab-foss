# frozen_string_literal: true

class CreateProjectSettings < ActiveRecord::Migration[5.0]
  DOWNTIME = false

  def change
    create_table :project_settings do |t|
      t.references :project,
                   null: false,
                   index: { unique: true },
                   foreign_key: { on_delete: :cascade }

      t.integer :forking_access_level,
                default: Gitlab::ForkingAccessLevel::ENABLED,
                null: false, limit: 2

      t.integer :fork_visibility_level,
                default: Gitlab::ForkVisibilityLevel::PARENT_VISIBILITY,
                null: false, limit: 2

      t.timestamps_with_timezone null: false
    end
  end
end
