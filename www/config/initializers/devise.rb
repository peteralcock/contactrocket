# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
require 'devise/orm/active_record'
require 'omniauth'
require 'omniauth-oauth2'
require 'doorkeeper'

# require 'devise-async'
# Devise::Async.backend = :sidekiq
# require 'devise_ldap_authenticatable'

module OmniAuth
  module Strategies
    class Doorkeeper < OmniAuth::Strategies::OAuth2
      # change the class name and the :name option to match your application name
      option :name, :doorkeeper

      option :client_options, {
          :site => "http://#{ENV['APP_HOST']}",
          :authorize_url => "/oauth/authorize"
      }

      uid { raw_info["id"] }

      info do
        {
            :email => raw_info["email"]
            # and anything else you want to return to your API consumers
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me.json').parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end


Devise.setup do |config|

  Devise::Doorkeeper.configure_devise(config)
   config.skip_session_storage = [:http_auth] # this is the default devise config
   config.allow_unconfirmed_access_for = 24.hours
   config.mailer_sender = 'hello@your-server.net'
   config.secret_key = ""
   config.case_insensitive_keys = [:email]
   config.strip_whitespace_keys = [:email]
   config.email_regexp = /\A[^@\s]+@[^@\s]+\z/


  # Set up a pepper to generate the hashed password.
  # Send a notification email when the user's password is changed
   config.send_password_change_notification = true
   config.stretches = 20

  # Invalidates all the remember me tokens when the user signs out.
   config.expire_all_remember_me_on_sign_out = true

   config.password_length = 8..128

   config.reset_password_keys = [:email]

   config.reset_password_within = 6.hours

   config.sign_in_after_reset_password = true

   config.encryptor = :sha512

   config.pepper = ""

   config.sign_out_via = :get

   config.reconfirmable = false

end


