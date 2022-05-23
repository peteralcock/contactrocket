require 'csv'
require 'json'
class DashboardController < ApplicationController
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token, :only => [:create_target]
  after_filter :allow_iframe, only: [:crm, :analytics]

  def marketing_campaigns

    @campaigns = current_user.campaigns
    @stats = {}

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  def marketing_reports

     @stats = {}

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  def marketing_templates

     @stats = {}

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end


  def leads

    @leads = current_user.leads
    @stats = {}

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  def helpdesk
    @stats = {}
    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  def accounts

    @accounts = current_user.accounts
    @stats = {}

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  def opportunities

    @opportunities = current_user.opportunities

    @stats = {}

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end
  def campaigns

    @campaigns = current_user.campaigns

    @stats = {}

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  def contacts

    @contacts = current_user.contacts

    @stats = {}
    @stats[:bandwidth] =  current_user.bandwidth_used.value
    @stats[:mileage] = current_user.mileage.value
    @stats[:page_urls] = current_user.pages_crawled.members
    @stats[:job_ids] =  current_user.job_ids.members
    @stats[:batch_ids] =  current_user.job_ids.members
    @stats[:workers] =  current_user.active_engines.value

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  def profile

    @user = current_user

    if @user.subscription
      @subscription = current_user.subscription
      if @subscription.plan
        @plan = @subscription.plan
      end
    end

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end

  def tasks

    @tasks = current_user.tasks

    @stats = {}

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end




  def index

    @websites = current_user.websites
    @user_tags = current_user.all_tags

    @stats = {}

    respond_to do |format|
        format.html
        format.json
        format.js
      end
  end


  def hq

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end


  def analytics
    @global_email_lead_count = current_user.email_leads.count
    @global_phone_lead_count = current_user.phone_leads.count
    @global_social_lead_count = current_user.social_leads.count
    @global_website_count = current_user.websites.count
    @global_lead_count = current_user.leads.count
    @global_user_count = User.count

    @websites = current_user.websites
    @phones = current_user.phone_leads
    @emails = current_user.email_leads
    @socials = current_user.social_leads
    @leads = current_user.leads
    @contacts = current_user.contacts
    @opportunities = current_user.opportunities

    @tasks = current_user.tasks
    @stats = {}
    @stats[:bandwidth] =  (current_user.bandwidth_used.value.to_f / 1024).round
    @stats[:mileage] = current_user.mileage.value
    @stats[:page_urls] = current_user.pages_crawled.members
    @stats[:job_ids] =  current_user.job_ids.members
    @stats[:batch_ids] =  current_user.job_ids.members
    @stats[:workers] =  current_user.active_engines.value

    respond_to do |format|
      format.html
      format.json
      format.js
    end
  end


  def import
    result = Website.import(params[:file], current_user.id)
    if result
      flash[:notice] = "Targets acquired, please wait..."
    end
    redirect_to root_url
  end



  def create_target


  if current_user.active_engines.value >= current_user.max_engines
    flash[:please_wait] = "ENGINES ARE BUSY, PLEASE WAIT..."
   elsif  current_user.websites.count > current_user.max_targets
  flash[:please_wait] = "PLEASE UPGRADE TO CONTINUE..."
     else
      if params[:url] and current_user.websites.count < current_user.max_targets

        if current_user.subscription and params[:url].match(",")
          urls = params[:url].split(",")
          urls.each do |url|
          unless url.match(/https?:\/\/.*$/i) or url.match(/http?:\/\/.*$/i) or url.match("http")
            url = "http://#{url}"
          end

          jid = SpiderWorker.perform_async(url, current_user.id, url)
          if jid
            current_user.job_ids << jid
          end
          end

        else

            url = params[:url]

          unless url.match(/https?:\/\/.*$/i) or url.match(/http?:\/\/.*$/i) or url.match("http")
            url = "http://#{url}"
          end

          jid = SpiderWorker.perform_async(url, current_user.id, url)
          if jid
            current_user.job_ids << jid
          end
        end

      end

   end


    redirect_to :back

  end



  def target_params
    params.permit(:url)
  end



end




