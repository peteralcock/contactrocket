
require 'curb'
require 'socket'

  class GeoipController < ApplicationController
    skip_before_filter :verify_authenticity_token

    def locate

      if params[:domain]
        domain = params[:domain]
      else
        url = params[:url]
        url.gsub!(" ", "")
        uri = URI.parse(url)
        domain = uri.host || url.rpartition("://")[2].rpartition("/")[0]
      end

      ip = IPSocket::getaddress(domain)
      result = Curl.get("http://#{ENV['API_HOST']}:8882/locate?ip=#{ip}")

      if result
        render :json => result.body_str
      else
        render status: :unprocessable_entity
      end

    end

  end
