require 'curb'
require 'socket'

module Api::V1
  class GeoipController < ApplicationController

    def locate
      url = params[:url]
      url.gsub!(" ", "")
      uri = URI.parse(url)
      if params[:domain]
        domain = params[:domain]
      else
        domain = uri.host || url.rpartition("://")[2].rpartition("/")[0]
      end

      ip = IPSocket::getaddress(domain)
      result = Curl.get("http://#{ENV['API_HOST']}:8000/locate?ip=#{ip}")
      if result
        render :json => result.body_str
      else
        render status: :unprocessable_entity
      end
    end

  end
end

