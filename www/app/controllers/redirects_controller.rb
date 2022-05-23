class RedirectsController < ApplicationController

def redirect
  redirect_to params[:redirect_url]
end



end
