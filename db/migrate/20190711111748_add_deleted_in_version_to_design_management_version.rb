# frozen_string_literal: true

class AddDeletedInVersionToDesignManagementVersion < ActiveRecord::Migration[5.1]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def change
    change_table :design_management_designs do |t|
      t.references :deleted_in_version,
                   null: true,
                   type: :bigint,
                   foreign_key: {
                     on_delete: :cascade,
                     to_table: :design_management_versions
                   }
    end
  end
end
