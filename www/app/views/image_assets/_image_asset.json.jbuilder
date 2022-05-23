json.extract! image_asset, :id, :image_url, :source_url, :keywords, :sentiment, :description, :domain, :website_id, :created_at, :updated_at
json.url image_asset_url(image_asset, format: :json)