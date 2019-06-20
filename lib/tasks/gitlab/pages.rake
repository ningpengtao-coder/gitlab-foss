namespace :gitlab do
  namespace :pages do
    desc 'Ping the pages admin API'
    task admin_ping: :gitlab_environment do
      Gitlab::PagesClient.ping
      puts "OK: gitlab-pages admin API is reachable"
    end

    desc "Makes all pages sites public(needed to enable access-control on gitlab.com)"
    task make_all_public: :environment do
      ::Gitlab::BackgroundMigration::MakeAllPagesSitesPublic.new.perform
    end
  end
end
