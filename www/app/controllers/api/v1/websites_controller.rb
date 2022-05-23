module Api::V1
  class WebsitesController < ApiController
    def index
      if params[:domain]
        render json: Website.where(:domain => params[:domain]).first, only: [:domain, :updated_at]
      else
        render json: "NOT FOUND"
      end
    end
  end
end

