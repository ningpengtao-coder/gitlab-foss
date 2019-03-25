# frozen_string_literal: true

class CreatePaasClusters < ActiveRecord::Migration[5.0]
  DOWNTIME = false

  def change
    create_table :paas_clusters, id: :bigserial do |t|
      t.string :name, null: false
      t.text :api_url, null: false
      t.text :ca_cert
      t.text :encrypted_token
      t.string :encrypted_token_iv

      t.timestamps_with_timezone null: false
    end
  end
end
