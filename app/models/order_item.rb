class OrderItem < ApplicationRecord
  belongs_to :product, class_name: Product.name
  belongs_to :order, class_name: Order.name
end
