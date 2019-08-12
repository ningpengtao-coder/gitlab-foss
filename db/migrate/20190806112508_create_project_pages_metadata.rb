# frozen_string_literal: true

class CreateProjectPagesMetadata < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def change
    create_table :project_pages_metadata do |t|
      t.references :project, null: false, index: { unique: true }, foreign_key: { on_delete: :cascade }, type: :integer
      t.timestamps_with_timezone null: false
      t.boolean :deployed, null: false, default: false, index: true
    end
  end
end
