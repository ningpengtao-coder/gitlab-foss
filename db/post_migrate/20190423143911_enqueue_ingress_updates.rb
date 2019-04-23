# frozen_string_literal: true

class EnqueueIngressUpdates < ActiveRecord::Migration[5.0]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  MIGRATION = 'UpdateIngressApplication'
  BATCH_SIZE = 1000
  DELAY_INTERVAL = 45.minutes.to_i

  class Ingress < ActiveRecord::Base
    include EachBatch

    self.table_name = 'clusters_applications_ingress'
  end

  disable_ddl_transaction!

  def up
    Ingress.each_batch(of: BATCH_SIZE) do |relation, index|
      delay = DELAY_INTERVAL * index
      min, max = relation.pluck('MIN(id)', 'MAX(id)').first

      BackgroundMigrationWorker.perform_in(delay, MIGRATION, [min, max])
    end
  end

  def down
    # no-op
  end
end
