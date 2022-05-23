FactoryGirl.define do
  factory :user do
    confirmed_at Time.now
    name FFaker::Name.name
    email FFaker::Internet.disposable_email
    password SecureRandom.hex(8)
    confirmation_token SecureRandom.hex(24)
  end
end
