#
#
# require 'rails_helper'
# require 'curb'
# require 'socket'
# require 'json'
# RSpec.describe TextController, type: :controller do
#
#   describe "POST #sentiment" do
#     it "returns text sentiment" do
#       response = nil
#       result = Curl.post("http://localhost:3000/text/sentiment", {:text => "I am very happy today!"})
#       if result
#         response = result.body_str
#       end
#       expect(response).to be_truthy
#       expect(response).to match("score")
#       puts response
#     end
#   end
#
#    describe "POST #nlp" do
#      it "returns text NLP and NER" do
#        response = nil
#        result = Curl.post("http://localhost:3000/text/nlp", {:text => "I am Peter Alcock from Boston, MA."})
#        if result
#          response = result.body_str
#        end
#        expect(response).to be_truthy
#        expect(response.to_s).to match("score")
#      end
#    end
#
#
# =begin
#   describe "POST #chat" do
#     it "returns chatbot conversation" do
#       response = nil
#       result = Curl.post("http://localhost:3000/text/chat", {:text => "Hello."})
#       if result
#         response = result.body_str
#       end
#       expect(response).to be_truthy
#       puts response
#     end
#   end
# =end
#
#
#   describe "POST #summarize" do
#     it "returns text summary" do
#       response = nil
#       result = Curl.post("http://localhost:3000/text/summarize", {:text => "Once time on a boat, a man fell. He was heroically rescued by Mr. Thomas. But I am Peter Alcock from Boston, MA."})
#       if result
#         response = result.body_str
#       end
#       expect(response).to be_truthy
#       puts response
#
#      end
#   end
#
#   describe "POST #analyze" do
#     it "returns text analysis" do
#       response = nil
#       result = Curl.post("http://localhost:3000/text/analyze", {:text => "I am Peter Alcock from Boston, MA."})
#       if result
#         response = result.body_str
#       end
#       expect(response).to be_truthy
#       expect(response.to_s).to match("emotion")
#       puts response
#
#     end
#   end
#
# end
#
#