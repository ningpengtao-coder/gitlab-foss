class Gitlab::Seeder::Users
  include ActionView::Helpers::NumberHelper

  RANDOM_USERS_COUNT = 20
  MASS_USERS_COUNT = 1_000_000

  attr_reader :opts

  def initialize(opts = {})
    @opts = opts
  end

  def seed!
    Sidekiq::Testing.inline! do
      create_random_users!
      create_mass_users!
    end
  end

  private

  def create_random_users!
    RANDOM_USERS_COUNT.times do |i|
      begin
        User.create!(
          username: FFaker::Internet.user_name,
          name: FFaker::Name.name,
          email: FFaker::Internet.email,
          confirmed_at: DateTime.now,
          password: '12345678'
        )

        print '.'
      rescue ActiveRecord::RecordInvalid
        print 'F'
      end
    end
  end

  def create_mass_users!
    encrypted_password = Devise::Encryptor.digest(User, '12345678')

    Gitlab::Seeder.with_mass_insert(MASS_USERS_COUNT, User) do
      User.insert_using_generate_series(1, MASS_USERS_COUNT) do |sql|
        sql.username = raw("'seed_user' || seq")
        sql.name = raw("'Seed user ' || seq")
        sql.email = raw("'seed_user' || seq || '@example.com'")
        sql.confirmed_at = raw("('2019-09-10'::date + seq)")
        sql.projects_limit = 10_000_000 # no limit
        sql.encrypted_password = encrypted_password
      end
    end

    # We can't use a sub-query here given we want to insert it just for the new
    # namespaces.
    Gitlab::Seeder.with_mass_insert(MASS_USERS_COUNT, Namespace, :batch) do
      existing_namespaces = Namespace.pluck(:id)
      User.where.not(id: existing_namespaces).find_in_batches(batch_size: 1_000) do |users|
        rows = users.map do |user|
          {
            name: user.username,
            path: user.username,
            owner_id: user.id
          }
        end

        Gitlab::Database.bulk_insert('namespaces', rows)
        print '.'
      end
    end
  end
end

Gitlab::Seeder.quiet do
  users = Gitlab::Seeder::Users.new
  users.seed!
end
