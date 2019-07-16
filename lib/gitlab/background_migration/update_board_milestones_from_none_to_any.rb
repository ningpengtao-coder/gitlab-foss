# frozen_string_literal: true
# rubocop:disable Style/Documentation

module Gitlab
  module BackgroundMigration
    class UpdateBoardMilestonesFromNoneToAny
      class Board < ActiveRecord::Base
        self.table_name = 'boards'
      end

      def perform(start_id, stop_id)
        Board.where(id: start_id..stop_id).update_all(milestone_id: nil)
      end
    end
  end
end
