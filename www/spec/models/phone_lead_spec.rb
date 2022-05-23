require 'rails_helper'

describe PhoneLead do
  before(:each) { @record = PhoneLead.new(:number => rand(2222222222...9999999999).to_s,
                                          :user_id => User.all.sample.id,
                                          :source_url => "http://contactrocket.local/test.html",
                                          :domain => FFaker::Internet.domain_name) }
  subject { @record }
  it { should respond_to(:is_valid) }
  it { should respond_to(:state) }
  it { should respond_to(:location) }
  it { should respond_to(:country) }
  it { should respond_to(:domain) }
  it { should respond_to(:phone_type) }
  it { should respond_to(:city) }
  it { should respond_to(:score) }
  it { should respond_to(:organization) }
  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:author) }
  it { should respond_to(:keywords) }


  it 'should add to CRM' do
    @record.get_page_text
    expect(@record.page_text).not_to eq(nil)

    expect(@record).not_to eq(nil)
    expect(@record.number).not_to eq(nil)
    @user = @record.user
    if @user.subscription
    @record.add_to_crm
    expect(@user).not_to eq(nil)
    expect(@record.user_id).not_to eq(nil)
    @crm_record = Lead.find_by(:first_name => @record.number, :user_id => @user.id)
    expect(@crm_record).not_to eq(nil)
    expect(@crm_record.user_id).not_to eq(nil)
    expect(@crm_record.user_id).to eq(@user.id)
    end

    end


end
