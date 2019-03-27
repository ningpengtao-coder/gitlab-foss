# frozen_string_literal: true

class CreatePaasServices < ActiveRecord::Migration[5.0]
  DOWNTIME = false

  def change
    create_table :paas_services, id: :bigserial do |t|
      t.string :name, null: false
      t.text :image, null: false
      t.string :domain

      t.references :namespace, type: :bigint, null: false, index: true, foreign_key: { to_table: :paas_namespaces, on_delete: :cascade }
    end
  end
end
