require 'rails_helper'

describe SocialLead do

  before(:each) { @record = SocialLead.new(:username => FFaker::Internet.user_name,
                                           :social_network => "facebook",
                                           :user_id => User.all.sample.id,
                                           :source_url => "http://contactrocket.local/test.html",
                                           :profile_url => ["http://facebook.com/", FFaker::Internet.user_name].join, :domain => [rand(99999).to_s, ".com"].join) }

  subject { @record }

  it { should respond_to(:city) }
  it { should respond_to(:state) }
  it { should respond_to(:location) }
  it { should respond_to(:country) }
  it { should respond_to(:organization) }
  it { should respond_to(:profile_url) }
  it { should respond_to(:username) }
  it { should respond_to(:website) }
  it { should respond_to(:social_network) }
  it { should respond_to(:score) }
  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:author) }

  it 'should add to CRM' do
    @record.get_page_text
    expect(@record.page_text).not_to eq(nil)
    expect(@record).not_to eq(nil)
    expect(@record.username).not_to eq(nil)
    @user = @record.user
    if @user.subscription
      @record.add_to_crm
      expect(@user).not_to eq(nil)
      expect(@record.user_id).not_to eq(nil)

      @crm_record = Lead.find_by(:first_name => "#{@record.username} (#{@record.social_network.to_s.humanize})", :user_id => @user.id)
      expect(@crm_record).not_to eq(nil)
      expect(@crm_record.user_id).not_to eq(nil)
      expect(@crm_record.user_id).to eq(@user.id)
    end
  end
end
