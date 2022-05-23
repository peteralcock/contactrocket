if Rails.env.development?




  require 'twitter'
  class TwitterBot

  # Module that holds all commands
  module Command
    def compliment(tweet)
      update(tweet, @compliments.sample)
    end

    private

    def update(tweet, msg)
      status = "@#{tweet.user.screen_name} #{msg}"
      @rest.update(status, in_reply_to_status_id: tweet.id).id
    end
  end

  include Command

  def initialize
    keys = {
        consumer_key: ENV['TWITTER_CONSUMER_KEY'],
        consumer_secret: ENV['TWITTER_CONSUMER_SECRET'],
        access_token: ENV['TWITTER_ACCESS_TOKEN'],
        access_token_secret: ENV['TWITTER_ACCESS_TOKEN_SECRET']
    }

    @rest = Twitter::REST::Client.new(keys)
    @stream = Twitter::Streaming::Client.new(keys)

    @compliments = [
        'You have beautiful eyes!',
        'You look nice today!',
        'I love your smile',
        'You are a smart cookie',
        'I bet you sweat glitter'
    ]
  end

  def listen
    @stream.user do |object|
      next unless object.is_a?(Twitter::Tweet)
      puts "#{object.text} - written by #{object.user.screen_name}"
      text = object.text.downcase

      Command.instance_methods.each do |command|
        if text.include?('please') && text.include?(command.to_s)
          puts "run: #{command}"
          send(command, object)
        end
      end
    end
  end
end
end
