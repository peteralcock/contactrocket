json.extract! brain, :id, :user_id, :name, :brain_type, :brain_gender, :brain_aiml, :aiml_id, :speed, :aiml_file, :created_at, :updated_at
json.url brain_url(brain, format: :json)