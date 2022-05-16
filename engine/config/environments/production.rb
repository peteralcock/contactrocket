Rails.application.configure do


  # Code is not reloaded between requests.
  config.cache_classes = true

  config.eager_load = true

  config.log_level = :warn

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new
  config.action_mailer.smtp_settings = {
      address: "email-smtp.us-east-1.amazonaws.com",
      port: 587,
      domain: "your-server.net",
      authentication: "plain",
      enable_starttls_auto: true,
      user_name: "",
      password: ""
  }

  config.action_mailer.default_url_options = { :host => "your-server.net" }
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false

end

