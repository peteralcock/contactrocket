FactoryGirl.define do
  factory :email_lead do
    address FFaker::Internet.disposable_email
    domain  FFaker::Internet.domain_name
  end
end
