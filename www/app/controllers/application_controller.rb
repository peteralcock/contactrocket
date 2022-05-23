
class ApplicationController < ActionController::Base

  # include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
   protect_from_forgery   with: :exception
   before_action :configure_permitted_parameters, if: :devise_controller?
  # after_action :track_action


   def configure_permitted_parameters
     update_attrs = [:password, :password_confirmation, :current_password]
     devise_parameter_sanitizer.permit :account_update, keys: update_attrs
   end

   private

   def self.force_ssl(options = {})
     host = options.delete(:host)
     before_filter(options) do
       if !request.ssl? && !Rails.env.development? #&& !(respond_to?(:allow_http?) && allow_http?)
         redirect_options = {:protocol => 'https://', :status => :moved_permanently}
         redirect_options.merge!(:host => host) if host
         redirect_options.merge!(:params => request.query_parameters)
         redirect_to redirect_options
       end
     end
   end

 # if Rails.env.production?
 #  force_ssl
 # end


  # payload[:request_id] = request.uuid
 #  payload[:user_id] = current_user.id if current_user
  # payload[:visit_id] = ahoy.visit_id # if you use Ahoy
  # protected

 #  def track_action
 #    ahoy.track "User interaction: #{controller_name}##{action_name}"
 #  end
   private
   def allow_iframe
     response.headers.delete "X-Frame-Options"
   end
end
