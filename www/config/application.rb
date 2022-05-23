
require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'
require 'iconv'
# require 'wc'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
#require 'apartment/elevators/generic' # or 'domain' or 'generic'


module ContactRocket
  class Application < Rails::Application

    config.middleware.use Rack::Attack
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*',
                 :headers => :any,
                 :expose  => ['access-token', 'expiry', 'token-type', 'uid', 'client'],
                 :methods => [:get, :post, :options, :delete, :put]
      end
    end

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end
    #config.action_dispatch.default_headers = { 'X-Frame-Options' => 'ALLOW-FROM https://crm.your-server.net' }
    config.action_dispatch.default_headers = { 'X-Frame-Options' => 'ALLOWALL' }

    # config.middleware.insert_before 'Warden::Manager', 'Apartment::Elevators::Subdomain'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Eastern Standard Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end

# Rails.application.config.middleware.use 'Apartment::Elevators::Domain'
# Rails.application.config.middleware.use 'Apartment::Elevators::Subdomain'
# Rails.application.config.middleware.use 'Apartment::Elevators::Generic'
# Rails.application.config.middleware.use 'Apartment::Elevators::FirstSubdomain'
# Apartment::Elevators::Subdomain.excluded_subdomains = ['www', 'crm', 'auth', 'my', 'api']