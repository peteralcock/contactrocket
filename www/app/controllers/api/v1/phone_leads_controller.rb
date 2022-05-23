module Api::V1
class PhoneLeadsController < ApiController

  def index
    if params[:q]
      @records = PhoneLead.search "#{params[:q]}", limit: 500
      render :json => @records
    elsif params[:domain]
      render json: PhoneLead.where(:domain => params[:domain]), only: [:number]
    else
      render json: "NOT FOUND"
    end

  end
end
end

