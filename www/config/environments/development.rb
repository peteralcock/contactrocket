Rails.application.configure do

  config.cache_classes = false
    config.eager_load = false
    config.consider_all_requests_local       = false
    config.action_controller.perform_caching = false
    config.action_dispatch.rack_cache = false
    config.serve_static_files = true
    config.assets.js_compressor = :uglifier
    config.assets.css_compressor = :sass
    config.assets.compile = true
    config.assets.digest = false
    config.log_level = :warn
    config.i18n.fallbacks = true
    config.active_support.deprecation = :notify
    config.action_mailer.default_url_options = { :host => "contactrocket.local:3000" }
    config.action_mailer.delivery_method = :test
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true
    config.log_formatter = ::Logger::Formatter.new
    config.active_record.dump_schema_after_migration = true
    config.action_dispatch.default_headers = {
        'X-Frame-Options' => 'ALLOWALL'
    }


end
