class RegistrationsController < Devise::RegistrationsController


  protected

  def after_sign_up_path_for(resource)
    "http://#{ENV['CRM_HOST']}/enter?email=#{resource.email}&uid=#{resource.uid}&redirect=yes"
  end

  def after_update_path_for(resource)
    "http://#{ENV['CRM_HOST']}/enter?email=#{resource.email}&uid=#{resource.uid}&redirect=yes"
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def reset(resource)
    resource.send_reset_password_instructions
    flash[:success] ="Check your inbox for instructions on resetting your password"
    redirect_to :root_path
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password, :username, :name, :accept_terms_of_service, :plan_id, :plan, :role)
  end



end
