FactoryBot.define do
  factory :user_info do
    name { "name" }
    phoneNum { "0987654321" }
    address { "Fake Address" }
    user
  end
end
