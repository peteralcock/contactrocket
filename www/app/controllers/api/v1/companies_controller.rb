module Api::V1
  class CompaniesController < ApiController

  def index
        if params[:q]
          @companies = Company.search "#{params[:q]}", limit: 500
          render json: @companies, only: [:company_name]
        elsif params[:domain]
          render json: Company.where(:domain => params[:domain]), only: [:company_name]
        else
          render json: "NOT FOUND"
        end
  end

  def show
    render json: Company.find(params[:id])
  end

  end
end

