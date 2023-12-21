class Order < ApplicationRecord
  enum type_payment: {cod: 0, bank: 1}
  enum status: {processing: 0, confirmed: 1, shipping: 2, delivered: 3}
  has_many :order_items, dependent: :destroy
  belongs_to :user_info
  belongs_to :user
  validates :note, length: {maximum: Settings.digit_255}
end
