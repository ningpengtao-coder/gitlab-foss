# frozen_string_literal: true

class SchedulePagesMetadataMigration < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false
  BATCH_SIZE = 1_000
  MIGRATION = 'MigratePagesMetadata'

  disable_ddl_transaction!

  class Project < ActiveRecord::Base
    include ::EachBatch

    self.table_name = 'projects'
  end

  def up
    Project.each_batch(of: BATCH_SIZE) do |relation, index|
      delay = index * 1.minute

      range = relation.pluck('MIN(id)', 'MAX(id)').first

      BackgroundMigrationWorker.perform_in(delay, MIGRATION, range)
    end
  end

  def down
    # no-op
  end
end
