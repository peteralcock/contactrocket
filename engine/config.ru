# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
# require 'sidekiq'
# require 'sidekiq/web'
# require 'sidekiq/pro/web'

require 'sidekiq/rack/batch_status'
use Sidekiq::Rack::BatchStatus
run Rails.application
# run Sidekiq::Web





#####


# # config.ru
# require 'sidekiq/web'
# require 'sidekiq-statistic'
#
# use Rack::Session::Cookie, secret: 'some unique secret string here'
# Sidekiq::Web.instance_eval { @middleware.reverse! } # Last added, First Run
# run Sidekiq::Web