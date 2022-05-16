require 'rails_helper'
require 'securerandom'

RSpec.describe SpiderWorker, :type => :worker do

  it 'downloads contacts' do
    @user = User.all.sample
    url = "http://contactrocket.dev/test.html"
    s = SpiderWorker.new
    result = s.perform(url, @user.id, url)
    if result
      expect(result).to be_truthy
    end

  end

end