module Api::V1
  class PeopleController < ApiController

    def index
      if params[:q]
        @records = Person.search "#{params[:q]}", limit: 500
        render :json => @records
      else
        render json: Person.first(500)
      end
    end

    def show
      render json: Person.find(params[:id])
    end

    end
end

