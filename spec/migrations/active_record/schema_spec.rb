require 'spec_helper'

# Check consistency of db/schema.rb version, migrations' timestamps, and the latest migration timestamp
# stored in the database's schema_migrations table.

describe ActiveRecord::Schema do
  let(:latest_migration_timestamp) do
    migrations_paths = %w[db ee/db]
      .product(%w[migrate post_migrate])
      .map { |path| Rails.root.join(*path, '*') }

    migrations = Dir[*migrations_paths]
    migrations.map { |migration| File.basename(migration).split('_').first.to_i }.max
  end

  it '> schema version should equal the latest migration timestamp stored in schema_migrations table' do
    expect(latest_migration_timestamp).to eq(ActiveRecord::Migrator.current_version.to_i)
  end
end
