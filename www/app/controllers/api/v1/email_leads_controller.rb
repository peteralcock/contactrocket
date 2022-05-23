module Api::V1
  class EmailLeadsController < ApiController
  def index
    if params[:q]
      @records = EmailLead.search "#{params[:q]}", limit: 500
      render :json => @records
    elsif params[:domain]
      render json: EmailLead.where(:domain => params[:domain]), only: [:address]
    else
      render json: "NOT FOUND"
    end
  end

end
end


