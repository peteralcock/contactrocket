class VisitorsController < ApplicationController

  def index
    if current_user
      redirect_to :signed_in_root_path
    end
  end


  def faq
    respond_to do |format|
      format.html
    end
  end


  def terms
    respond_to do |format|
      format.html
    end
  end

  def unsubscribe
    respond_to do |format|
      format.html
    end
  end


end

