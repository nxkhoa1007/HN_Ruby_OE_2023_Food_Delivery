class Order < ApplicationRecord
  enum type_payment: {cod: 0, bank: 1}
  enum status: {processing: 0, confirmed: 1, shipping: 2,
                delivered: 3, canceled: 4}

  has_many :order_items, dependent: :destroy

  belongs_to :user_info
  belongs_to :user

  validates :note, length: {maximum: Settings.digit_255}

  scope :newest, ->{order(created_at: :asc)}

  def save_order_code
    update_column :order_code, generate_order_code(id)
  end

  def cancel_order
    update_column :status, :canceled
  end

  private

  def generate_order_code order_id
    "#KF#{order_id.to_s.rjust(6, '0')}"
  end
end
