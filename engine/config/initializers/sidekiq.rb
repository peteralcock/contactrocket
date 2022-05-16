require 'sidekiq'
require 'sidekiq-status'
require 'sidekiq/pro/expiry'

unless Rails.env.production?
  require 'sidekiq-benchmark/testing'
end

sidekiq_config = { host: ENV['REDIS_HOST'], network_timeout: 60 }
Sidekiq::Logging.logger.level = Logger::INFO

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add Sidekiq::Hierarchy::Client::Middleware
    chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
 #   chain.add Sidekiq::Statsd::ServerMiddleware, env: "production", prefix: "worker", host: "localhost", port: 8125
    chain.add Sidekiq::Hierarchy::Server::Middleware
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
  end
  config.client_middleware do |chain|
    chain.add Sidekiq::Hierarchy::Client::Middleware
    chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
  end
end
