module Api::V1
  class WorkersController < ApiController

  def analyze_text
    if params[:text]
      @hash = {}
      result = Worker.analyze_text(params[:text])
      render json: result
    else
      render status: :unprocessable_entity
    end
  end


    def image_to_entities
      image_text = Curl.post("http://#{ENV['API_HOST']}:8008/ocr", {:img_url => params[:image_url]})
      if image_text and image_text.body
        entities = Curl.post("http://#{ENV['API_HOST']}:5000/api", {:text => image_text.body, :worker => "tesseract"})
        if entities
          render json: entities.body
        end
      end
    end


  def extract_images
    if params[:url]
      result = Worker.extract_images(params[:url])
      render json: result
    else
      render status: :unprocessable_entity
    end
  end

  def extract_article
    if params[:url]
      result = Worker.extract_article(params[:url])
      render json: result
    else
      render status: :unprocessable_entity
    end
  end
  
  def extract_product
    if params[:url]
      result = Worker.extract_product(params[:url])
      render json: result
    else
      render status: :unprocessable_entity
    end
  end

  def extract_entities
    if params[:text]
      result = Worker.extract_entities(params[:text])
      render json: result
    else
      render status: :unprocessable_entity
    end
  end
  
  def validate_email
    if params[:email]
      result = Worker.validate_email(params[:email])
      render json: result
    else
      render status: :unprocessable_entity
    end
  end

  
  def analyze_email
    if params[:email]
      result = Worker.analyze_email(params[:email])
      render json: result
    else
      render status: :unprocessable_entity
    end
  end
  
  def analyze_phone
    if params[:number]
      result = Worker.analyze_phone(params[:number])
      render json: result
    else
      render status: :unprocessable_entity
    end
  end
  
  def analyze_name
    if params[:first_name] and params[:last_name]
      result = Worker.analyze_name(params[:first_name], params[:last_name])
      render json: result
    else
      render status: :unprocessable_entity
    end
  end
  
  def analyze_domain
    if params[:domain]
      result = Worker.analyze_domain(params[:domain])
      render json: result
    else
      render status: :unprocessable_entity
    end
  end
  
  def social_shares
    if params[:url]
      result = Worker.social_shares(params[:url])
      render json: result
    else
      render status: :unprocessable_entity
    end
  end


  def train_image
    result = Worker.post("http://#{ENV['API_HOST']}:8080", "/train", {:url => params[:url], :tags => params[:tags]})
    render json: result
  end




  def ocr_image
    result = Worker.ocr_image(params[:url])
    render json: result.to_s
  end


  def add_image
    result = Worker.post("http://#{ENV['API_HOST']}:8888", "/add", {:url => params[:url]}) #, :filepath => filepath})
    render json: result
  end


  def predict_image
    result = Worker.predict_image(params[:url])
    render json: result
  end


  def compare_image
    result = Worker.post("http://ENV['API_HOST']:8888", "/compare", {:url1 => params[:url1], :url2 => params[:url2]})
    render json: result
  end

  def search_image
    result = Worker.post("http://ENV['API_HOST']:8888", "/search", {:url => params[:url]})
    render json: result
  end

  def delete_image
    result = Worker.post("http://ENV['API_HOST']:8888", "/delete", {:filepath => params[:filepath]})
    render json: result
  end


  def crawl
    if params[:url] and @user
      result = Worker.crawl(params[:url], @user.id)
      render json: result
    else
      render status: :unprocessable_entity
    end
  end
end

end
