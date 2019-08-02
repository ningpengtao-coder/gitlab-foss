# frozen_string_literal: true

class ChangeEnvironmentsStateDefault < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def up
    change_column_default(:environments, :state, 'created')
  end

  def down
    change_column_default(:environments, :state, 'available')
  end
end
