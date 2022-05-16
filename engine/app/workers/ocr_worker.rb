class OcrWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :backtrace => true

  def perform(image_url)
      image_text = Curl.post("http://#{ENV['API_HOST']}:8008/ocr", {:img_url => image_url})
      if image_text and image_text.body
        entities = Curl.post("http://#{ENV['API_HOST']}:5000/api", {:text => image_text.body, :worker => "tesseract"})
        if entities
          return entities.body
        end
      end
  end

end

