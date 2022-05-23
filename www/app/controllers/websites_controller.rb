class WebsitesController < ApplicationController
  before_action :authenticate_user!
 
 
  def index
    @search_path = "/websites"
 
    if params[:q]
      @websites = Website.search params[:q], limit: 100,  misspellings: {edit_distance: 2} # fields: [:address, :domain], match: :word_start,
      @search_term = params[:q]
    else
      @websites = current_user.websites.include([:email_leads,:phone_leads,:social_leads]).paginate(:page => params[:page]).order('id DESC')
    end
    @websites ||= []

    respond_to do |format|
      format.csv { send_data @websites.to_csv, filename: "websites-#{Date.today}.csv" }
      format.html
      format.js
      format.json { render json: @websites }
    end
  end

  def import
    if params[:file] and current_user
      result = Website.import(params[:file], current_user.id)
      if result
        flash[:notice] = "Targets acquired, please wait..."
      end
    end
    redirect_to root_url
  end


  def delete
    e = Website.find(params[:id])
    if e.user_id == current_user.id
      e.delete
    end
    redirect_to :back
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_website
    @website = Website.find(params[:id])
  end


end
