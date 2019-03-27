# frozen_string_literal: true

class CreatePaasNamespaces < ActiveRecord::Migration[5.0]
  DOWNTIME = false

  def change
    create_table :paas_namespaces, id: :bigserial do |t|
      t.string :name, null: false
      t.references :project, index: true, foreign_key: { on_delete: :nullify }
      t.references :cluster, null: false, index: true, foreign_key: { on_delete: :cascade }

      t.timestamps_with_timezone null: false
    end
  end
end
