=begin

require 'rails_helper'
require 'curb'
require 'socket'
require 'json'
RSpec.describe ImageController, type: :controller do


   describe "POST detect" do
     it "returns keywords" do
       result = Curl.post("http://www.contactrocket.local:3000/image/detect", {:url => "http://i.ytimg.com/vi/0vxOhd4qlnA/maxresdefault.jpg"})
       expect(result).to be_truthy
       expect(result.body_str).to match("football")
     end
   end

   # describe "POST ocr" do
   #   it "returns OCR" do
   #     result = Curl.post("http://localhost:3000/image/ocr", {:url => "http://bit.ly/ocrimage"})
   #     response = result.body_str
   #     expect(response).to be_truthy
   #     expect(response.to_s).to match("You can create")
   #   end
   # end

end

=end
