require 'curb'
require 'securerandom'
class Bot

  def initialize(user_id, greeting)

    @guest = User.find(user_id)
    @convo_id = SecureRandom.hex(12)
    @message = greeting
    resp = Curb.get(ENV['CHATBOT_URL'])
    @last_reply = resp.body

  end

  def conversation_id
    @convo_id
  end

  def latest
    @message
  end

  def train(call,response)

  end

  def add_aiml(aiml)

  end

  def del_aiml(aiml)

  end

  def load_aiml(aiml)

  end

end