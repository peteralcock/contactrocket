require 'rails_helper'

describe EmailLead do
  before(:each) { @record = EmailLead.new(:user_id => 1,
                                          :address => FFaker::Internet.disposable_email,
                                          :source_url => "http://contactrocket.local/test.html",
                                          :domain => [rand(99999).to_s, ".com"].join) }
  subject { @record }

  it { should respond_to(:is_valid) }
  it { should respond_to(:domain) }
  it { should respond_to(:academia) }
  it { should respond_to(:govt) }
  it { should respond_to(:score) }
  it { should respond_to(:organization) }
  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:author) }


  it 'should add to CRM' do
    @record.get_page_text
    expect(@record.page_text).not_to eq(nil)

    expect(@record).not_to eq(nil)
    expect(@record.address).not_to eq(nil)
    @user = @record.user
    if @user.subscription
      @record.add_to_crm
      expect(@user).not_to eq(nil)
      expect(@record.user_id).not_to eq(nil)

      @crm_record = Lead.find_by(:first_name => @record.address, :user_id => @user.id)
      expect(@crm_record).not_to eq(nil)
      expect(@crm_record.user_id).not_to eq(nil)
      expect(@crm_record.user_id).to eq(@user.id)
    end

  end

end
