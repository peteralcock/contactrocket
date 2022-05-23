
require 'curb'
require 'json'
  class ImageController < ApplicationController
    skip_before_filter :verify_authenticity_token

    def detect
      url = params[:url]
      url.gsub!(" ", "")
      payload =  {:service => "imageserv", :parameters => {:input => {:width => 224, :height => 224 }, :output => {:best => 3}, :mllib => {:gpu => false}}, :data => ["#{url}"]}.to_json
      result = Curl.post("http://#{ENV['API_HOST']}:8883/predict", payload)
      parsed = JSON.parse(result.body_str)
      sorted_results = []
      parsed["body"]["predictions"][0]["classes"].each do |tag|
        delete_me = tag["cat"].split(" ").first
        words = tag["cat"].split(delete_me).last.strip
        probability = (tag["prob"] * 100).round(1)
        sorted_results << [probability, words]
      end
      scores = sorted_results.sort_by {|x| x[0]}.reverse
      resp = scores.to_json
      if result
        render :json => resp
      else
        render status: :unprocessable_entity
      end
    end





    def ocr
      if params[:url]
        uri = URI.parse("http://#{ENV['API_HOST']}:9292")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new("/ocr")
        request.add_field('Content-Type', 'application/json')
        request.body =  {:img_url => params[:url], :worker => "tesseract"}.to_json
        response = http.request(request)
        render :json => response.body
      else
        return false
      end
    end



    def ping

    end

    def list

    end

    def add

    end

    def delete

    end

    def search

    end

    def compare

    end



  end


