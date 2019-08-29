# frozen_string_literal: true

class BackfillReleaseNameWithTag < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  disable_ddl_transaction!

  def up
    subquery = Arel.sql("select id from projects where visibility_level = #{Gitlab::VisibilityLevel::PUBLIC}")

    update_column_in_batches(:releases, :name, Release.arel_table[:tag]) do |table, query|
      query.where(table[:name].eq(nil)).where(table[:project_id].in(subquery))
    end
  end

  def down
    # noop
  end
end
