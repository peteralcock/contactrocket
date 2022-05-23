class SocialLeadsController < ApplicationController
  before_action :authenticate_user!



  def remove
    contact = SocialLead.find(params[:id])
    current_user.quicklist.delete contact.profile_url
    flash[:notice] = "#{contact.username} has been removed from prospects"
    redirect_to :back
  end

  def reset
    if SocialLead.where(:user_id => current_user.id).delete_all
      flash[:notice] = "Contacts have been removed from your account"
    end
    redirect_to :back
  end

  def top_ten
    networks = Array.new
    SocialLead.all.each do |social|
    networks << social.social_network
    end
    @top_ten = networks.each_with_object(Hash.new(0)){ |m,h| h[m] += 1 }.sort_by{ |k,v| v }.reverse
    return @top_ten
  end

  def valid
    b = SocialLead.find(params[:id])
    if b and b.user_id == current_user.id
      b.is_valid = true
      b.save
      flash[:notice] = "#{b.username} is a valid profile"
    end
    redirect_to :back
  end

  def add
    b = SocialLead.find(params[:id])
    if b and b.user_id == current_user.id
      if b.add_to_crm
        flash[:new_lead] = "#{b.username} was added to CRM"
        b.delete
      else
        flash[:subscribers_only] = "#{b.username} was not added to CRM"
      end
    end
    redirect_to :back
  end


  def delete
    e = SocialLead.find(params[:id])
    if e.user_id == current_user.id
      e.delete
    end
    redirect_to :back
  end


  def index
    @search_path = "/social_leads"

    if params[:q]
      @contacts = SocialLead.search params[:q], limit: 50, misspellings: {edit_distance: 2}, where: {:user_id => current_user.id}
      @search_term = params[:q]
      @contacts = @contacts.results
    else
      @contacts = current_user.social_leads.paginate(:page => params[:page])
     end
      @contacts ||= []

    respond_to do |format|
      format.csv { send_data current_user.social_leads.to_csv, filename: "social-contacts-#{Date.today}.csv" }
      format.html
      format.js
      format.json { render json: @contacts }
    end
  end




end
