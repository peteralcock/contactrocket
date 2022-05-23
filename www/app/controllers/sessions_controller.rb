
class SessionsController < Devise::SessionsController

  protected
  def after_sign_in_path_for(resource)
     Apartment::Tenant.switch!(resource.uid)
     cookies[:user_id] = resource.id
    "http://#{ENV['CRM_HOST']}/enter?email=#{resource.email}&uid=#{resource.uid}"
  end

end