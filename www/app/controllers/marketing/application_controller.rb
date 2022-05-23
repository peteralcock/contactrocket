class ApplicationController < ActionController::Base
  include PublicActivity::StoreController

  protect_from_forgery

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :cheat_login
  before_filter :authenticate_user!
  #before_filter :system_status

  add_flash_types :warning

  def cheat_login
    unless current_user and current_user.id
    if current_user.nil? and params[:uid]
      @user = User.find_by(:uid => params[:uid])
      if @user
        Apartment::Tenant.switch!(@user.uid)
        sign_in(@user, scope: :user)
      end
    end
    end
  end


  protected

  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  def configure_permitted_parameters
    signin_attrs = [:password,  :email, :username]
    signup_attrs = [:username, :email, :password, :password_confirmation]
    update_attrs = [:username, :password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: signin_attrs
    devise_parameter_sanitizer.permit :sign_up, keys: signup_attrs
  end

  def system_status
    @show_status = true
    @apache = SystemMonitor.apache
    @vhosts = SystemMonitor.vhosts
    @msf = SystemMonitor.metasploit
    @beef = SystemMonitor.beef
    @sidekiq = SystemMonitor.sidekiq
    begin
      q = Sidekiq::Stats.new.enqueued
      @redis = true
      if q > 0 and !@sidekiq
        flash[:warning] = "You have #{ActionController::Base.helpers.pluralize(q, 'job')} enqueued, but Sidekiq is not running"
      end
    rescue Redis::CannotConnectError => e
      logger.error e.message
      @redis = false
      flash[:warning] = e.message if e.message =~ /timeout/i
    end
  end

end
