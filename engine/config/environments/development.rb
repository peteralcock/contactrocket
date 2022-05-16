Rails.application.configure do
    ENV['API_HOST'] = "localhost"
    ENV['CRM_HOST'] = "localhost:3001"
    ENV['APP_HOST'] = "localhost:3000"
    ENV['ELASTICSEARCH_URL'] = "http://localhost:9200/"

        ENV['REDIS_HOST'] = "localhost"
    # Code is not reloaded between requests.
    config.cache_classes = false

    config.eager_load = false

    config.log_level = :info

    # Use default logging formatter so that PID and timestamp are not suppressed.
    config.log_formatter = ::Logger::Formatter.new
    config.action_mailer.default_url_options = { :host => "localhost:3000" }
    config.action_mailer.delivery_method = :letter_opener
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true
end
