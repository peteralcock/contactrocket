class SearchesController < ApplicationController
  before_action :authenticate_user!

  def index

     if params[:q] and current_user.subscription and (current_user.search_count.value < current_user.max_searches)
         @businesses = Company.search params[:q], limit: 25, suggest: true, track: { user_id: current_user.id }
         current_user.search_count.incr
         @suggestions = @businesses.suggestions
     else
       @businesses = []
     end

       respond_to do |format|
        format.html
        format.json
        format.js
        # format.csv { send_data @businesses.to_csv, filename: "business-cards-#{Date.today}.csv" }
       end
  end


  def search_params
    params.permit(:q)
  end

end



