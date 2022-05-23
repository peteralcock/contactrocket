module Api::V1
    class ApiController < ApplicationController
      respond_to :json
    #  before_action :authenticate
    #  after_action :dock_credits

      def authenticate
        user_email = request.headers['X-User-Email']
        api_key = request.headers['X-User-Token']
        @user = User.where(authentication_token: api_key, email: user_email).first if api_key and user_email
          unless @user
            head status: :unauthorized
          end
      end
    end
end
