# This file is copied to spec/ when you run 'rails generate rspec:install'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode! Hit the deck!") if Rails.env.production?
require 'ffaker'
require 'rspec/core'
require 'rspec/rails'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/core_ext/object/blank'
require 'serverspec'
set :backend, :exec # :ssh
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.fuubar_progress_bar_options = { :format => '>>> TESTS RUNNING <%B> %p%% %a' }

  config.filter_rails_from_backtrace!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.infer_spec_type_from_file_location!

end


if ENV['SERVERSPEC']

  set :ssh_options, :user => 'vagrant', :password => 'vagrant', :host_name => 'gitlab.dev'
  host = "gitlab.dev"
  options = Net::SSH::Config.for(host)
  user = options[:user] = 'vagrant'
  options[:password] = 'vagrant'
  ENV['SUDO_PASSWORD'] =  options[:password]
  set :host, options[:host_name] || host
  set :ssh_options, options
  set :disable_sudo, true
  set :path, '/sbin:/usr/local/sbin:$PATH'


  RSpec.configure do |c|
    c.host  = host
    c.request_pty = true
    c.ssh = Net::SSH.start(c.host, user)
  end

end


