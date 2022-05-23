class HealthCheckController < ApplicationController

  def index
    render :text => "OK"
  end


  protected
  def allow_http?
    true
  end

end
