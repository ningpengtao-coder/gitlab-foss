# frozen_string_literal: true
# rubocop:disable Style/Documentation

module Gitlab
  module BackgroundMigration
    class UpdateBoardMilestonesFromNoneToAny
      class Board < ActiveRecord::Base
        self.table_name = 'boards'
      end

      def perform(start_id, stop_id)
        Rails.logger.info("Setting board milestones from None to Any: #{start_id} - #{stop_id}") # rubocop:disable Gitlab/RailsLogger

        update = 'UPDATE boards SET milestone_id = null'

        Board.where(id: start_id..stop_id).update_all(update)
      end
    end
  end
end
