class ChangeAuthorIdToNotNullInTodos < ActiveRecord::Migration[4.2]
  include Gitlab::Database::MigrationHelpers

  class Todo < ActiveRecord::Base
    self.table_name = 'todos'
    include EachBatch
  end

  BATCH_SIZE = 1000

  DOWNTIME = false

  disable_ddl_transaction!

  def up
    Todo.where(author_id: nil).each_batch(of: BATCH_SIZE, &:delete_all)

    change_column_null :todos, :author_id, false
  end

  def down
    change_column_null :todos, :author_id, true
  end
end
