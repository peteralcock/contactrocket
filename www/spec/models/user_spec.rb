

require 'rails_helper'
random_email = FFaker::Internet.disposable_email

describe User do
  before(:each) { @user = User.find_or_create_by(email: random_email) }
  subject { @user }

  it { should respond_to(:authentication_token) }
  it { should respond_to(:username) }
  it { should respond_to(:email) }
  it { should respond_to(:uid) }

  it "creates user accounts" do
    expect(@user.email).to match random_email
    expect(@user.email).to eq(random_email)
    expect(@user.uid.blank?).not_to eq(true)
    expect(@user.max_searches).to eq(5)
    expect(@user.max_engines).to eq(4)
    expect(@user.max_targets).to eq(20)
    expect(@user.max_contacts).to eq(150)
    expect(@user.max_validations).to eq(10)
    expect(@user.max_pages).to eq(1000)
    expect(@user.max_bandwidth).to eq(10000000)

  end



end



