# frozen_string_literal: true

class AddSecretWordToSnippet < ActiveRecord::Migration[5.0]
  DOWNTIME = false

  def change
    add_column :snippets, :encrypted_secret, :string, limit: 25
    add_column :snippets, :encrypted_secret_iv, :string, limit: 25
    add_column :snippets, :encrypted_secret_salt, :string, limit: 25
  end
end
