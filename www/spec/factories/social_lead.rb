FactoryGirl.define do
  factory :social_lead do
    profile_url FFaker::Internet.http_url
    domain FFaker::Internet.domain_name
    username FFaker::Internet.user_name
    social_network ["facebook", "twitter", "github", "google", "linkedin", "pinterest", "instagram"].sample
  end
end
