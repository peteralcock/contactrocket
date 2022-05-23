# This file is copied to spec/ when you run 'rails generate rspec:install'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode! Hit the deck!") if Rails.env.production?
require 'ffaker'
require 'rspec/core'
require 'rspec/rails'
require 'net/ssh'
require 'pathname'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/core_ext/object/blank'
require 'net/ssh'
require 'pathname'
require 'capybara/rails'
require 'capybara/session'
require 'capybara/rspec'
require 'capybara/webkit/matchers'
require "selenium-webdriver"

if ENV['CI']
  require 'headless'
  headless = Headless.new(display: 99, autopick: true, reuse: false, destroy_at_exit: true).start
end

Capybara.default_driver = :selenium
Capybara.default_wait_time = 10
Capybara.ignore_hidden_elements = true
# Capybara.default_selector = :css

set :backend, :exec
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }




RSpec.configure do |config|


  config.fuubar_progress_bar_options = { :format => '>> TESTING... <%B> %p%% %a' }

  config.filter_rails_from_backtrace!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.infer_spec_type_from_file_location!

  config.include(Capybara::Webkit::RspecMatchers, :type => :feature)

end