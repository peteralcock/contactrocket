set :application, 'contactrocket'
set :stage, 'production'
set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, false
set :keep_releases, 2
set :sidekiq_config,  'config/sidekiq.yml'
set :sidekiq_processes, 2
set :sidekiq_concurrency, 10
set :sidekiq_default_hooks , true
set :sidekiq_timeout, 60
set :sidekiq_monit_conf_dir , '/etc/monit/conf.d'
set :sidekiq_monit_use_sudo , true
set :sidekiq_monit_default_hooks , true
#set :sidekiq_pid , File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid')
#set :sidekiq_log , File.join(shared_path, 'log', 'sidekiq.log')
#set :sidekiq_options , nil
#set :sidekiq_require , nil
#set :sidekiq_tag , nil
#set :sidekiq_config , "config/sidekiq.yml" # if you have a config/sidekiq.yml, do not forget to set this.
#set :sidekiq_queue , nil
#set :monit_bin , '/usr/bin/monit'
#set :sidekiq_processes , 4
#set :sidekiq_options_per_process , nil
#set :sidekiq_concurrency , 10
#set :sidekiq_monit_templates_path , 'config/deploy/templates'
#set :sidekiq_service_name , "sidekiq_#{fetch(set :application)}_#{fetch(set :sidekiq_env)}"
#set :sidekiq_cmd , "#{fetch(set :bundle_cmd, "bundle")} exec sidekiq" # Only for capistrano2.5
#set :sidekiqctl_cmd , "#{fetch(set :bundle_cmd, "bundle")} exec sidekiqctl" # Only for capistrano2.5
#set :sidekiq_user , nil #user to run sidekiq as
