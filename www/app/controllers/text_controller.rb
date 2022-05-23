require 'curb'
require 'socket'
require 'summarize'
require 'json'

  class TextController < ApplicationController
    skip_before_filter :verify_authenticity_token
    @@wl = WhatLanguage.new(:all)
    @@tgr = EngTagger.new

    def nlp
      data = {:text => params[:text] }
      result = Curl.post("http://#{ENV['API_HOST']}:8880/", data)

      if result
        render :json => result.body_str.to_json
      else
        render status: :unprocessable_entity
      end
    end

    def  analyze
      if params[:text]
        text = params[:text]
        hash = {}
        tagged = @@tgr.add_tags(text)
        hash[:word_list] =  @@tgr.get_words(text)
        hash[:nouns] = @@tgr.get_nouns(tagged)
        hash[:proper_nouns] = @@tgr.get_proper_nouns(tagged)
        hash[:past_tense_verbs] = @@tgr.get_past_tense_verbs(tagged)
        hash[:adjectives] =  @@tgr.get_adjectives(tagged)
        hash[:noun_phrases] = @@tgr.get_noun_phrases(tagged)
        hash[:language] = @@wl.language(text)
        hash[:languages_ranked] = @@wl.process_text(text)
        hash[:profanity] = SadPanda.polarity (text)
        hash[:emotion] = SadPanda.emotion (text)
        hash[:reading_level] = Odyssey.coleman_liau (text)
        if hash
          render :json => hash.to_json
        else
          render status: :unprocessable_entity
        end
      end
    end



    def sentiment
      result = Curl.post("http://#{ENV['API_HOST']}:8880/", {:text => "#{params[:text]}"})
      if result
        render :json => result.body_str.to_json
      else
        render status: :unprocessable_entity
      end
    end


    def summarize
      result = params[:text].to_s.summarize
      if result
        render :json => result
      else
        render status: :unprocessable_entity
      end
    end

    def chat
      result = Curl.get("http://#{ENV['API_HOST']}:8069/chatbot/conversation_start.php", {:bot_id=>6, :say=>params[:message], :convo_id=>params[:user_id], :format=>"json"})
      if result
        render :json => result.body_str
      else
        render status: :unprocessable_entity
      end
    end

  end


