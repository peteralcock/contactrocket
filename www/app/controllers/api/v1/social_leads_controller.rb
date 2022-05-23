module Api::V1
  class SocialLeadsController < ApiController

    def index
      if params[:q]
        @records = SocialLead.search "#{params[:q]}", limit: 100
        render :json => @records
      elsif params[:domain]
        render json: SocialLead.where(:domain => params[:domain]), only: [:username, :social_network, :profile_url]
      else
        render json: "NOT FOUND"
      end
      end

end
end
