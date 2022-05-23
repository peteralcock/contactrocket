require "oauth2"
require "omniauth"
require 'omniauth-oauth2'
require "securerandom"
require "socket"       # for SocketError
require "timeout"      # for Timeout::Error

module OmniAuth
  module Strategies

    class OAuth2
      include OmniAuth::Strategy
      def self.inherited(subclass)
        OmniAuth::Strategy.included(subclass)
      end

      args [:client_id, :client_secret]
      option :client_id,  ENV['API_KEY']
      option :client_secret,  ENV['API_SECRET']
      option :client_options,  { site:  'https://auth.your-server.net' , :redirect_uri => 'https://www.your-server.net/users/auth/wordpress_hosted/callback' }
      option :authorize_params, {}
      option :authorize_options, [:scope]
      option :token_params, {}
      option :token_options, []
      option :auth_token_params, {}
      option :provider_ignores_state, false
      attr_accessor :access_token

      def client
        ::OAuth2::Client.new(options.client_id, options.client_secret, deep_symbolize(options.client_options))
      end

      def callback_url
        full_host + script_name + callback_path
      end

      credentials do
        hash = {"token" => access_token.token}
        hash.merge!("refresh_token" => access_token.refresh_token) if access_token.expires? && access_token.refresh_token
        hash.merge!("expires_at" => access_token.expires_at) if access_token.expires?
        hash.merge!("expires" => access_token.expires?)
        hash
      end

      def request_phase
        redirect client.auth_code.authorize_url({:redirect_uri => callback_url}.merge(authorize_params))
      end

      def authorize_params
        options.authorize_params[:state] = SecureRandom.hex(24)
        params = options.authorize_params.merge(options_for("authorize"))
        if OmniAuth.config.test_mode
          @env ||= {}
          @env["rack.session"] ||= {}
        end
        session["omniauth.state"] = params[:state]
        params
      end

      def token_params
        options.token_params.merge(options_for("token"))
      end

      def callback_phase
        error = request.params["error_reason"] || request.params["error"]
        if error
          fail!(error, CallbackError.new(request.params["error"], request.params["error_description"] || request.params["error_reason"], request.params["error_uri"]))
        elsif !options.provider_ignores_state && (request.params["state"].to_s.empty? || request.params["state"] != session.delete("omniauth.state"))
          fail!(:csrf_detected, CallbackError.new(:csrf_detected, "CSRF detected"))
        else
          self.access_token = build_access_token
          self.access_token = access_token.refresh! if access_token.expired?
          super
        end
      rescue ::OAuth2::Error, CallbackError => e
        fail!(:invalid_credentials, e)
      rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
        fail!(:timeout, e)
      rescue ::SocketError => e
        fail!(:failed_to_connect, e)
      end

    protected

      def build_access_token
        verifier = request.params["code"]
        client.auth_code.get_token(verifier, {:redirect_uri => callback_url}.merge(token_params.to_hash(:symbolize_keys => true)), deep_symbolize(options.auth_token_params))
      end

      def deep_symbolize(options)
        hash = {}
        options.each do |key, value|
          hash[key.to_sym] = value.is_a?(Hash) ? deep_symbolize(value) : value
        end
        hash
      end

      def options_for(option)
        hash = {}
        options.send(:"#{option}_options").select { |key| options[key] }.each do |key|
          hash[key.to_sym] = options[key]
        end
        hash
      end

      class CallbackError < StandardError
        attr_accessor :error, :error_reason, :error_uri

        def initialize(error, error_reason = nil, error_uri = nil)
          self.error = error
          self.error_reason = error_reason
          self.error_uri = error_uri
        end

        def message
          [error, error_reason, error_uri].compact.join(" | ")
        end
      end
    end

    class ContactRocketOAuth2 < OmniAuth::Strategies::OAuth2
      uid{ raw_info['id'] }

      info do
        {
            :name => raw_info['user_login'],
            :email => raw_info['user_email']
        }
      end

      extra do
        {
            'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/oauth/me').parsed
      end
    end

  end
end
OmniAuth.config.add_camelization "oauth2", "OAuth2"
