class CompaniesController < ApplicationController
  before_action :authenticate_user!

  def autocomplete
    render json: Company.search(params[:query], {
        fields: ["company_name^5", "industry"],
        limit: 10,
        load: false,
        misspellings: {below: 5}
    }).map(&:company_name)
  end

  def index

     if params[:query] and current_user.subscription and (current_user.search_count.value < current_user.max_searches)
         @companies = Company.search params[:query], limit: 25, suggest: true, track: { user_id: current_user.id }
         current_user.search_count.incr
         @suggestions = @companies.suggestions
     else
       @companies = []
     end

       respond_to do |format|
        format.html
        format.json
        format.js
        # format.csv { send_data @companies.to_csv, filename: "business-cards-#{Date.today}.csv" }
       end
  end


  def company_params
    params.permit(:query)
  end

end



