class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController


  def wordpress_hosted
    #You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_wordpress_hosted(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      session[:current_crm_user_id] = current_user.crm_user.id
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    else
      session["devise.wordpress_hosted_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

end



