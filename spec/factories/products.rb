FactoryBot.define do
  factory :product do
    name { "Product Name" }
    cost { "25000" }
    description { "This is a product description." }
    after(:build) do |product|
      product.image.attach(
        io: File.open(Rails.root.join("spec", "assets", "images", "test.jpg")),
        filename: "test.jpg",
        content_type: "image/jpeg")
    end
  end
end
