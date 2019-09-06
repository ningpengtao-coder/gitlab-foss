# frozen_string_literal: true

class CreateDescriptionChanges < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def change
    create_table :description_changes do |t|
      t.references :system_note, index: true, foreign_key: { to_table: :notes }, null: false
      t.text :old_description
      t.text :new_description
    end
  end
end
