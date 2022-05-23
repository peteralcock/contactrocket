require 'rails_helper'


RSpec.describe Worker, :type => :model do

  it 'extracts text entities' do
    result = Worker.analyze_text("I am Bob Smith and I am from Boston, MA. I work for Coca Cola Inc.")
    expect(result.to_s).to match("Bob")
  end

#  it 'crawls product data' do
#    result = Worker.extract_product("http://www.bestbuy.com/site/garmin-nuvi-2589lmt-5-gps-with-built-in-bluetooth-lifetime-map-updates-and-lifetime-traffic-updates-black/8161046.p?id=1219314436512&skuId=8161046")
#    expect(result).to be_truthy
#  end


  it 'estimates ethnicities' do
    result = Worker.analyze_name("Peter", "Alcock")
    expect(result.to_s).to match("white")
    expect(result.to_s).to match("male")
    expect(result.to_s).to match('"white"=>"87.95"')
  end

  it 'analyzes email addresses' do
    analyze_result = Worker.analyze_email("support@your-server.net")
    expect(analyze_result).to be_truthy
  end

  it 'analyzes phone numbers' do
    result = Worker.analyze_phone("5555555555")
    expect(result).to be_truthy
    phone = PhoneLead.find_by(:number => "5555555555")
    if phone
      expect(phone.area_code).not_to eq(nil)
      expect(phone.number_type).not_to eq(nil)
      expect(phone.country).not_to eq(nil)
      expect(phone.state).not_to eq(nil)
      expect(@record.location).to eq("NY")
      expect(@record.number).to eq("5555555555")
      expect(@record.better_number).to eq("(555)-555-5555")
    end

  end

  it 'scores social media' do
    result = Worker.social_shares("http://example.com")
    expect(result).to be_truthy
  end

  it 'checks search page rankings' do
    result = Worker.get_page_rank("http://example.com")
    expect(result).to be_truthy
  end

  if Rails.env.production?

  it 'classifies images' do
    result =  Worker.new_image_service
    expect(result).to be_truthy
    url = "http://i.ytimg.com/vi/0vxOhd4qlnA/maxresdefault.jpg"
    result = Worker.predict_image(url)
    expect(result.to_s).to match("football")
  end

  it 'validates emails' do
    check_result = Worker.check_email("sales@your-server.net")
    expect(check_result).to be_truthy
  end

  it 'even does OCR' do
    result = Worker.ocr_image("http://bit.ly/ocrimage")
    expect(result).to match("You can create local variables for the pipelines within the template")
  end


  end


end

 

 