class EmailLeadsController < ApplicationController
  before_action :authenticate_user!
  @quicklist = []

  def valid
    b = EmailLead.find(params[:id])
    if b and b.user_id == current_user.id
      b.is_valid = true
      b.save
      flash[:notice] = "#{b.address} has been validated"
    end
    redirect_to :back
  end

  def add
    b = EmailLead.find(params[:id])
    if b and b.user_id == current_user.id
      if b.add_to_crm
        flash[:new_lead] = "#{b.address} was added to CRM"
        b.delete
      else
        flash[:subscribers_only] = "#{b.address} was not added to CRM"
      end
    end
    redirect_to :back
  end



  def index
    @search_path = "/email_leads"
    @quicklist = []
    if params[:q]
      @contacts = EmailLead.search params[:q], limit: 50,  misspellings: {edit_distance: 2}, where: {:user_id => current_user.id}
      @contacts = @contacts.results # fields: [:address, :domain], match: :word_start,
      @search_term = params[:q]
    else
      @contacts = current_user.email_leads.paginate(:page => params[:page]).order('id DESC')
    end
    @contacts ||= []

    respond_to do |format|
      format.csv { send_data current_user.email_leads.to_csv, filename: "emails-#{Date.today}.csv" }
      format.html
      format.js
      format.json { render json: @contacts }
    end
  end


  def reset
    if EmailLead.where(:user_id => current_user.id).delete_all
      flash[:notice] = "All unqualified leads have been deleted"
    end
    redirect_to :back
  end


  def delete
    e = EmailLead.find(params[:id])
        if e.user_id == current_user.id
          e.delete
        end
    redirect_to :back
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email
      @email = EmailLead.find(params[:id])
    end


end
