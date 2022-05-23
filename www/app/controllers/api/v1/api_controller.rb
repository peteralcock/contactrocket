module Api::V1
    class ApiController < ApplicationController
      respond_to :json
   #   before_action :authenticate
   #   after_action :dock_credits

      def api_call
        endpoint = params[:endpoint]
        if current_user.api_credits.decrement
          http = Curl.get(endpoint)
          return http.body_str
        else
          head status: :unauthorized
        end
      end

      def authenticate
          user_email = request.headers['X-User-Email']
          api_key = request.headers['X-User-Token']
          @user = User.where(authentication_token: api_key, email: user_email).first if api_key and user_email
          unless @user
            head status: :unauthorized
          end
      end

      def dock_credits
        if @user
          @user.api_credits.decrement
        end
      end


      private
      def current_resource_owner
        User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

    end
end
