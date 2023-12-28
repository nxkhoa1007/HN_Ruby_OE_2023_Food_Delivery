FactoryBot.define do
  factory :user do
    name { "Name" }
    password {"11111111"}
    email { "name@gmail.com" }
    after(:build) do |user|
      user.avatar.attach(
        io: File.open(Rails.root.join("spec", "assets", "images", "test.jpg")),
        filename: "test.jpg",
        content_type: "image/jpeg")
    end
  end
end
