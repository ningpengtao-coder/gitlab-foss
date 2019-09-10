# frozen_string_literal: true

class BackfillReleaseNameWithTag < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  disable_ddl_transaction!

  def up
    table = Project.arel_table
    subquery = table.project(table[:id]).where(table[:visibility_level].eq(Gitlab::VisibilityLevel::PUBLIC))

    update_column_in_batches(:releases, :name, Release.arel_table[:tag]) do |table, query|
      query.where(table[:name].eq(nil)).where(table[:project_id].in(subquery))
    end

    update_column_in_batches(:releases, :name, Arel.sql("'release-' || id")) do |table, query|
      query.where(table[:name].eq(nil)).where(table[:project_id].not_in(subquery))
    end
  end

  def down
    # noop
  end
end
