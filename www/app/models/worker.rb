
class Worker
  @@wl = WhatLanguage.new(:all)
  @@tgr = EngTagger.new
  @@validator = ValidationWorker.new


  def self.post(url, path, body={})
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(path)
    request.add_field('Content-Type', 'application/json')
    request.body =  body.to_json
    response = http.request(request)
    response.body
  end


  def self.new_image_service
    system("curl -X PUT 'http://#{ENV['API_HOST']}:8080/services/imageserv' -d '{\"mllib\":\"caffe\",\"description\":\"image classification service\",\"type\":\"supervised\",\"parameters\":{\"input\":{\"connector\":\"image\"},\"mllib\":{\"nclasses\":1000}},\"model\":{\"repository\":\"/opt/models/ggnet/\"}}'")
  end


  def self.predict_image(url)
    body = {"service"=>"imageserv", "parameters"=>{"input"=>{"width"=>224, "height"=>224}, "output"=>{"best"=>3}}, "data"=>["#{url}"]}
    uri = URI.parse("http://#{ENV['API_HOST']}:8080")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new("/predict")
    request.add_field('Content-Type', 'application/json')
    request.body =  body.to_json
    response = http.request(request)
    response.body
  end


  def self.train_image(url, tags=[])
    body = {"service"=>"imageserv", "async"=>true, "parameters"=>{"mllib"=>{"gpu"=>false, "net"=>{"batch_size"=>32}, "solver"=>{"test_interval"=>500, "iterations"=>30000, "base_lr"=>0.001, "stepsize"=>1000, "gamma"=>0.9}}, "input"=>{"connector"=>"image", "test_split"=>0.1, "shuffle"=>true, "width"=>224, "height"=>224}, "output"=>{"measure"=>["acc", "mcll", "f1"]}}, "data"=>tags}
    uri = URI.parse("http://#{ENV['API_HOST']}:8880")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new("/train")
    request.add_field('Content-Type', 'application/json')
    request.body =  body.to_json
    response = http.request(request)
    response.body
  end



  def self.ocr_image(url)
    uri = URI.parse("http://#{ENV['API_HOST']}:9292")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new("/ocr")
    request.add_field('Content-Type', 'application/json')
    request.body =  {:img_url => url, :worker => "tesseract"}.to_json
    response = http.request(request)
    response.body
  end



def self.analyze_text(text)
  if text
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
    return hash
  else 
    return false
  end
end




def self.crawl(url, user_id)
  job_id = SecureRandom.hex(8)
  qid = SpiderWorker.perform_async(url, user_id, job_id)
  if qid
    return qid
  else
    return false
  end
end




  def self.get_page_rank(url)
     googlerank = GooglePageRank.get(url)
    if googlerank
      return googlerank
    else
      return false
    end
  end

  

def self.extract_product(url)
  if url
    hash = {}
    product  = Fletcher.fetch url
    hash[:product_name] = product.name # => "Avenir Deluxe Unicycle (20-Inch Wheel)"
    hash[:description] = product.description
  # hash[:image] = product.image.src || nil
    hash[:price] = product.price
    hash
  else
    return false
  end
end



def self.extract_entities(text)
  if text
    entities = @@ner.perform(text)
    if entities
      return entities
    else
      return false
    end
  end
end

def self.check_email(email_address)
  if email_address
    resp = EmailVerifier.check(email_address)
    if resp
      return resp
    else
      return false
    end
  end
end


def self.validate_email(email_address, user_id)
  resp = @@validator.perform(email_address, user_id)
  if resp
    return resp
  else
    return false
  end
end


def self.analyze_email(email_address)
  if email_address
    hash = {}
    email_domain = email_address.to_s.split("@").last
    school = Swot::school_name email_address
    govt_domain = Gman.new email_address
    hash[:domain] = email_domain
    if school
      hash[:academia] ||= school
    end
    if govt_domain
      hash[:govt_agency] = govt_domain.agency
      # hash[:domain] ||= govt_domain.domain
      hash[:is_govt] = govt_domain.federal?
      hash[:academia] ||= false
    end
    return hash
  else
    return false
  end
end

def self.analyze_phone(phone_number)
  if phone_number
    hash = {}
    identifier = Phonelib.parse(phone_number)
    hash[:number] = phone_number.phony_formatted(:normalize => :US, :spaces => '-')
    if phone_number[0].to_s == "1"
      area = phone_number.to_s[1..3]
    else
      area = phone_number.to_s[0..2]
    end
    hash[:region] = Integer(area).to_region(:city => true)
    hash[:type] = identifier.human_type
    hash[:country] = identifier.country
    hash[:location] = identifier.geo_name
    return hash
  else
    return false
  end
end


def self.analyze_name(first_name, last_name)
  if first_name and last_name
    hash = {}
    hash[:gender] = Guess.gender(first_name.to_s.humanize)
    hash[:ethnicity] = $races[last_name.to_s.upcase]
    hash[:name] = [first_name, last_name].join(" ")
    return hash
  else
    return false
  end
end

def self.analyze_domain(domain_name)
  if domain_name
    url = "http://#{domain_name}"
    hash = {}
    doc = Pismo::Document.new url
    whois_data = Whois.whois(domain_name)
    googlerank = GooglePageRank.get(url)
    meta = MetaInspector.new(url)
    if doc and doc.title
      hash[:title] = doc.title
      hash[:author] = doc.author
      hash[:meta_keywords] = doc.keywords
      hash[:meta_description] =  doc.description
    end
    if whois_data
      hash[:whois] = whois_data
    end
    if googlerank
      hash[:google_links] = googlerank.to_s
    end
    if meta
      hash[:meta] = meta.to_hash.to_s
    end
    return hash
  else
    return false
  end
end


def self.social_shares(social_media_url)
  if social_media_url
    result = SocialShares.all social_media_url
    return result
  else
    return false
  end
end

end
