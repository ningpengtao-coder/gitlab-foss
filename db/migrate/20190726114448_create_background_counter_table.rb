# frozen_string_literal: true

class CreateBackgroundCounterTable < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def change
    create_table :background_counters do |t|
      t.string :identifier, null: false, limit: 100

      t.datetime_with_timezone :updated_at, null: false
      t.bigint :counter_value, null: false, default: 0

      t.index :identifier, unique: true
    end
  end
end
