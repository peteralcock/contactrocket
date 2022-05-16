FactoryGirl.define do
  factory :website do
    domain  FFaker::Internet.domain_name
    url FFaker::Internet.http_url
  end
end
