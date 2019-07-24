# frozen_string_literal: true

class DefaultMilestoneToNil < ActiveRecord::Migration[5.1]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  disable_ddl_transaction!

  class Board < ActiveRecord::Base
    self.table_name = 'boards'

    include ::EachBatch
  end

  def up
    execute(update_board_milestones_query)
  end

  def down
    # no-op
  end

  private

  # Only 105 records to update, as of 2019/07/18
  def update_board_milestones_query
    <<~HEREDOC
   UPDATE boards
     SET milestone_id = NULL
   WHERE boards.milestone_id = -1
    HEREDOC
  end
end
