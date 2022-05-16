require 'rails_helper'
RSpec.describe Worker, :type => :model do

  it 'finds entities' do
    result = Worker.analyze_text("I am Bob Smith and I am from Boston, MA. I work for Coca Cola Inc.")
    expect(result.to_s).to match("Bob")
  end

 # it 'extracts product data' do
 #   result = Worker.extract_product("http://www.amazon.com/All-New-Amazon-Echo-Dot-Add-Alexa-To-Any-Room/dp/B01DFKC2SO")
 #   expect(result).to be_truthy
 # end

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

  it 'estimates ethnicity' do
    result = Worker.analyze_name("Peter", "Alcock")
    expect(result.to_s).to match("white")
    expect(result.to_s).to match("male")
    expect(result.to_s).to match('"white"=>"87.95"')

  end

  it 'analyzes emails' do
    analyze_result = Worker.analyze_email("admin@your-server.net")
    expect(analyze_result).to be_truthy
 #   check_result = Worker.check_email("admin@your-server.net")
 #   expect(check_result).to be_truthy
  end

  it 'analyzes targets' do
    result = Worker.get_page_rank("http://www.your-server.net")
    expect(result).to be_truthy
    result = Worker.social_shares("http://www.your-server.net")
    expect(result).to be_truthy
  end


 # it 'classifies images' do
 #   result =  Worker.new_image_service
 #   expect(result).to be_truthy
 #   url = "http://i.ytimg.com/vi/0vxOhd4qlnA/maxresdefault.jpg"
 #   result = Worker.predict_image(url)
 #   expect(result.to_s).to match("football")
 # end

 # it 'does OCR' do
 #  pending "Requires OCR service successfully built into production"
 #  result = Worker.ocr_image("http://bit.ly/ocrimage")
 #  expect(result).to match("You can create local variables for the pipelines within the template")
 # end

end



