
Rails.application.configure do

  # endpoint    = "example.urlthing.cfg.use1.cache.amazonaws.com:11211"
 # elasticache = Dalli::ElastiCache.new(endpoint)
#  config.cache_store = :mem_cache_store #, elasticache.servers, {:expires_in => 1.hour, :compress => true}
 # config.middleware.use Rack::SslEnforcer, :only_hosts => 'crm.your-server.net', :ignore => '/crm', :strict => true
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.action_dispatch.rack_cache = true
  config.serve_static_files = true
  config.assets.js_compressor = :uglifier
  config.assets.compile = true
  config.assets.digest = true
  config.log_level = :error
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.action_mailer.default_url_options = { :host => "your-server.net" }
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false

  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
  config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL'
  }


end
