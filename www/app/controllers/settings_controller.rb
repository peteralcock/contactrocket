class SettingsController < ApplicationController
before_action :authenticate_user!

  def index
    @api_credits = current_user.api_credits.value
    @contact_credits = current_user.contact_credits.value
    @emails = current_user.email_leads
    @phones = current_user.phone_leads
    @socials = current_user.social_leads
    respond_to do |format|
      format.html
    end
  end

def upgrade
  @api_credits = current_user.api_credits.value
  @contact_credits = current_user.contact_credits.value
  @emails = current_user.email_leads
  @phones = current_user.phone_leads
  @socials = current_user.social_leads
  respond_to do |format|
    format.html

  end

end




  def profile
    @api_credits = current_user.api_credits.value
    @contact_credits = current_user.contact_credits.value
    @emails = current_user.email_leads
    @phones = current_user.phone_leads
    @socials = current_user.social_leads
    respond_to do |format|
      format.html

    end

  end

end
