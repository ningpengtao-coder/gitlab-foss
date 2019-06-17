# frozen_string_literal: true

class SchedulePopulateNamespaceRootId < ActiveRecord::Migration[5.1]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false
  BATCH_SIZE = 10_000
  MIGRATION = 'PopulateNamespaceRootIdColumn'
  DELAY_INTERVAL = 10.minutes.to_i

  disable_ddl_transaction!

  class Namespace < ActiveRecord::Base
    self.table_name = 'namespaces'

    include EachBatch
  end

  def up
    say 'Scheduling `PopulateNamespaceRootIdColumn` jobs'

    # We currently have ~4_600_000 namespace records on GitLab.com
    # This means, the migration will schedule ~460 jobs (10k each) within a 10 minutes gap.
    # so this should take ~153 hours to complete (assuming 30k namespaces per hour)
    queue_background_migration_jobs_by_range_at_intervals(
      Namespace,
      MIGRATION,
      DELAY_INTERVAL,
      batch_size: BATCH_SIZE
    )
  end
end
