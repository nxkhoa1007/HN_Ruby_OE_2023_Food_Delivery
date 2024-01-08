class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  delegate :name, :image, to: :product, prefix: true

  def rate
    update_columns rated: true
  end
end
