require 'curb'
require 'socket'
require 'summarize'
require 'json'
module Api::V1
  class TextController < ApplicationController

    def nlp
      result = Curl.post("http://#{ENV['APP_HOST']}:5000/api", {:text => "#{params[:text]}"})
      if result
        render :json => result.body_str.to_json
      else
        render status: :unprocessable_entity
      end
    end

    def sentiment
      result = Curl.post("http://#{ENV['APP_HOST']}:8880", {:text => "#{params[:text]}"})
      if result
        render :json => result.body_str.to_json
      else
        render status: :unprocessable_entity
      end
    end


    def summarize
      result = params[:text].summarize
      if result
        render :json => result
      else
        render status: :unprocessable_entity
      end
    end

    def chat
      result = Curl.get("http://#{ENV['APP_HOST']}:8069/chatbot/conversation_start.php", {:bot_id=>6, :say=>params[:message], :convo_id=>params[:user_id], :format=>"json"})
      if result
        render :json => result.body_str
      else
        render status: :unprocessable_entity
      end
    end


  end
end

