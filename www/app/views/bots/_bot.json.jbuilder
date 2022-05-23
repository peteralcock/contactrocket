json.extract! bot, :id, :user_id, :name, :bot_type, :dict_file, :aiml_id, :brain_id, :bot_iq, :brain_speed, :created_at, :updated_at
json.url bot_url(bot, format: :json)