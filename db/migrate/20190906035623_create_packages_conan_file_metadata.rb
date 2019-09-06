# frozen_string_literal: true

class CreatePackagesConanFileMetadata < ActiveRecord::Migration[5.2]
  include Gitlab::Database::MigrationHelpers

  DOWNTIME = false

  def change
    create_table :packages_conan_file_metadata do |t|
      t.references :package_file, index: { unique: true }, null: false, foreign_key: { to_table: :packages_package_files, on_delete: :cascade }, type: :integer
      t.string "recipe", null: false, limit: 255
      t.string "path", null: false, limit: 255
      t.string "revision", null: false, default: "0", limit: 255

      t.timestamps_with_timezone
    end
  end
end
