# frozen_string_literal: true

class AddRootIdToNamespace < ActiveRecord::Migration[5.1]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def change
    add_column :namespaces, :root_id, :integer
  end
end
