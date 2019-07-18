# frozen_string_literal: true

class AddAutoDevopsBuildableToPipelines < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def change
    add_column :ci_pipelines, :auto_devops_buildable, :boolean
  end
end
