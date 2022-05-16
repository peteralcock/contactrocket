FactoryGirl.define do
  factory :phone_lead do
    number FFaker::PhoneNumber.phone_number
    domain FFaker::Internet.domain_name
    state FFaker::AddressUS.state_abbr
    source_url  FFaker::Internet.http_url
  end
end
