FactoryGirl.define do
  factory :company do
    company_name FFaker::Company.name
    state FFaker::AddressUS.us_state_abbr
    city FFaker::AddressUS.city
    domain  FFaker::Internet.domain_name
    website FFaker::Internet.http_url
  end
end
