class AddForeignKeysToTodos < ActiveRecord::Migration[4.2]
  include Gitlab::Database::MigrationHelpers

  class Todo < ActiveRecord::Base
    self.table_name = 'todos'
    include EachBatch
  end

  BATCH_SIZE = 1000

  DOWNTIME = false

  disable_ddl_transaction!

  def up
    Todo.where('NOT EXISTS ( SELECT true FROM users WHERE id=todos.user_id )').each_batch(of: BATCH_SIZE, &:delete_all)

    Todo.where('NOT EXISTS ( SELECT true FROM users WHERE id=todos.author_id )').each_batch(of: BATCH_SIZE, &:delete_all)

    Todo.where('note_id IS NOT NULL AND NOT EXISTS ( SELECT true FROM notes WHERE id=todos.note_id )').each_batch(of: BATCH_SIZE, &:delete_all)

    add_concurrent_foreign_key :todos, :users, column: :user_id, on_delete: :cascade
    add_concurrent_foreign_key :todos, :users, column: :author_id, on_delete: :cascade
    add_concurrent_foreign_key :todos, :notes, column: :note_id, on_delete: :cascade
  end

  def down
    remove_foreign_key :todos, column: :user_id
    remove_foreign_key :todos, column: :author_id
    remove_foreign_key :todos, :notes
  end
end
