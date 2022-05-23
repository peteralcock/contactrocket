class EventsController < ApplicationController
  before_action :authenticate_user!


  def batch
    batch = Sidekiq::Batch::Status.new(params[:bid]) # bid is the batch ID
    render json: batch
  end

  def progress
    @stats = {}
    @stats[:bandwidth] =  ((current_user.bandwidth_used.value.to_f / 1024).to_f / 1024).round
    @stats[:last_url] = current_user.pages_crawled.members.last
    @stats[:page_count] = current_user.pages_crawled.members.count
    @stats[:social_count] = current_user.social_leads.count
    @stats[:facebook_count] = current_user.social_leads.is_facebook.count
    @stats[:linkedin_count] = current_user.social_leads.is_linkedin.count
    @stats[:instagram_count] = current_user.social_leads.is_instagram.count
    @stats[:pinterest_count] = current_user.social_leads.is_pinterest.count
    @stats[:github_count] = current_user.social_leads.is_github.count
    @stats[:twitter_count] = current_user.social_leads.is_twitter.count
    @stats[:email_count] = current_user.email_leads.count
    @stats[:phone_count] = current_user.phone_leads.count
    @stats[:valid_email_count] = current_user.email_leads.is_valid.count
    @stats[:total_contacts] = current_user.total_contacts
    render json: @stats
  end


end
