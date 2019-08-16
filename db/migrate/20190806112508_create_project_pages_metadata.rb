# frozen_string_literal: true

class CreateProjectPagesMetadata < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def change
    create_table :project_pages_metadata, id: false do |t|
      t.references :project, null: false, index: { unique: true }, foreign_key: { on_delete: :cascade }
      t.boolean :deployed, null: false, default: false, index: true
    end
  end
end
