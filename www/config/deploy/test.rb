role :www, %w{vagrant@gitlab.local}
set :deploy_to, '/contactrocket/www'
server 'gitlab.local',
       user: 'vagrant',
       roles: %w{www},
       ssh_options: {
           user: 'vagrant',
           password: 'vagrant',
           auth_methods: %w(password)
       }
set :linked_files, %w{config/database.yml config/secrets.yml config/ooor.yml config/blazer.yml}
set :linked_dirs, %w{tmp/cache vendor/bundle public/system log tmp/sockets tmp/pids}
set :repo_url, 'http://git@gitlab.local:/contactrocket/www.git'
set :pty,             true
set :use_sudo,        true
set :scm,           :git
set :branch,        :staging
set :format,        :pretty
set :log_level,     :debug
set :keep_releases, 3
set :rvm_type, :user                    # Defaults to: :auto
set :rvm_ruby_version, '2.2.5'      # Defaults to: 'default'
# set :rvm_custom_path, '/home/ubuntu/.rvm'  # only needed if not detected

namespace :deploy do
       task :restart do
              system('touch /contactrocket/www/tmp/restart.txt')
       end

       after  :finishing,    :compile_assets
       after  :finishing,    :cleanup
       after  :finishing,    :restart
end

