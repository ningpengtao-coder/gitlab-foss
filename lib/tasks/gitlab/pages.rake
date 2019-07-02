namespace :gitlab do
  namespace :pages do
    desc 'Ping the pages admin API'
    task admin_ping: :gitlab_environment do
      Gitlab::PagesClient.ping
      puts "OK: gitlab-pages admin API is reachable"
    end

    desc "Makes enabled pages sites public(needed to enable access-control on gitlab.com)"
    task make_enabled_public: :environment do
      ::Gitlab::BackgroundMigration::MakeEnabledPagesSitesPublic.new.perform
    end
  end
end
