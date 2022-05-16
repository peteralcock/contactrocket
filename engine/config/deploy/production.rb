
set :stage, "production"
role :app, %w{ubuntu@your-server.net}
set :deploy_to, '/srv/contactrocket/engine'
server 'your-server.net',
       user: 'ubuntu',
       roles: %w{app},
       ssh_options: {
           user: 'ubuntu',
           keys: %w(/Users/machine/.ssh/rockbox.pem),
           forward_agent: true,
           auth_methods: %w(publickey)
       }

set :linked_files, %w{config/database.yml config/sidekiq.yml}
set :linked_dirs, %w{tmp/cache vendor/bundle log tmp/pids}


set :pty,             true
set :use_sudo,        true
set :scm,           :git
set :branch,        :master
set :format,        :pretty
set :log_level,     :debug
set :keep_releases, 2
set :local_repository, "file://."
set :deploy_via, :copy
# cache only seems to work if use scm
set :copy_cache, true
set :copy_via, :scp
set :copy_exclude, [".zeus*", ".bundle", ".git", "tmp/*", "doc", "log/*", "fixtures/*"]


task :deploy_from_local_repo do

  run_locally do
    execute "tar -zcvf /tmp/engine_repo.tgz .git"
  end
  set :repo_url,  "file:///tmp/.git"

  on roles(:app) do
    upload! '/tmp/engine_repo.tgz', '/tmp/engine_repo.tgz'
    execute 'tar -zxvf /tmp/engine_repo.tgz -C /tmp'
  end
end


task :remove_repo do
  on roles(:app) do
    execute "rm -rf /tmp/*.git"
  end
end


namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end


  before :deploy, :deploy_from_local_repo
  after  :finishing,    :cleanup
  after  :finishing,    :restart
  after :deploy, :remove_repo


end

