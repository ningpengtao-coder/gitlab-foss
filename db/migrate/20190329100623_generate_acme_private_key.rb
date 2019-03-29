# frozen_string_literal: true

# See http://doc.gitlab.com/ce/development/migration_style_guide.html
# for more information on how to write migrations for GitLab.

class GenerateAcmePrivateKey < ActiveRecord::Migration[5.0]
  include Gitlab::Database::MigrationHelpers

  # Set this constant to true if this migration requires downtime.
  DOWNTIME = false

  disable_ddl_transaction!

  def up
    update_column_in_batches(:application_settings, :acme_private_key, OpenSSL::PKey::RSA.new(4096).to_s)
  end

  def down
  end
end
