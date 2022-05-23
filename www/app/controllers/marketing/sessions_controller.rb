
class SessionsController < Devise::SessionsController

  protected
  def after_sign_in_path_for(resource)
    Apartment::Tenant.switch!(resource.uid)
    "http://#{ENV['CRM_HOST']}/enter?email=#{resource.email}&uid=#{resource.uid}"
  end

end