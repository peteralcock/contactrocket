class PhoneLeadsController < ApplicationController
  before_action :authenticate_user!
  @quicklist = []

  def remove
    contact = PhoneLead.find(params[:id])
    current_user.quicklist.delete contact.better_number
    flash[:notice] = "#{contact.better_number} removed from prospects"
    redirect_to :back
  end


  def reset
    if PhoneLead.where(:user_id => current_user.id).delete_all
      flash[:notice] = "Phone numbers have been deleted"
    end
    redirect_to :back
  end

  def add
    b = PhoneLead.find(params[:id])
    if b and b.user_id == current_user.id
      if b.add_to_crm
        flash[:new_lead] = "#{b.number} was added to CRM"
        b.delete
      else
        flash[:subscribers_only] = "#{b.number} was not added to CRM"
      end

    end
    redirect_to :back
  end

  def index
    @search_path = "/phone_leads"

    if params[:q]
    phone_number = params[:q].to_s.scan(/\d/).join
    @contacts = PhoneLead.search phone_number, limit: 50, misspellings: {edit_distance: 2}, where: {:user_id => current_user.id}
    @search_term = params[:q]
    @contacts = @contacts.results
  else
    @contacts = current_user.phone_leads.has_location.paginate(:page => params[:page])
  end
  @contacts ||= []

  respond_to do |format|
    format.csv { send_data current_user.phone_leads.to_csv, filename: "phone-numbers-#{Date.today}.csv" }
    format.html
    format.js
    format.json { render json: @contacts }
  end
end

  def valid
    b = PhoneLead.find(params[:id])
    if b and b.user_id == current_user.id
      b.is_valid = true
      b.save
      flash[:verified] = "#{b.better_number} is a valid phone number"
    end
    redirect_to :back
  end


def delete
    e = PhoneLead.find(params[:id])
  if e.user_id == current_user.id
    e.delete
  end
  redirect_to :back
end

  private
     def set_phone
      @phone = PhoneLead.find(params[:id])
    end


end
