#
#
# require 'rails_helper'
# require 'curb'
# require 'socket'
# require 'json'
# RSpec.describe  GeoipController, type: :controller do
#
#    describe "GET locate" do
#      it "returns location of URL" do
#        result = Curl.get("http://localhost:3000/website/locate", {:url => "http://google.com"})
#        if result
#          response = result.body_str
#        end
#        expect(response).to be_truthy
#        expect(response).to have_content("CA")
#        puts response
#      end
#    end
#
# end
#
#
