# frozen_string_literal: true
# rubocop:disable Style/Documentation

class DefaultMilestoneToNil < ActiveRecord::Migration[5.1]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  disable_ddl_transaction!

  class Board < ActiveRecord::Base
    self.table_name = 'boards'

    include ::EachBatch
  end

  def up
    Gitlab::BackgroundMigration.steal('UpdateBoardMilestonesFromNoneToAny')

    Board.where(milestone_id: -1).each_batch(of: 50) do |batch|
      range = batch.pluck('MIN(id)', 'MAX(id)').first

      Gitlab::BackgroundMigration::UpdateBoardMilestonesFromNoneToAny.new.perform(*range)
    end
  end

  def down
    # noop
  end
end
