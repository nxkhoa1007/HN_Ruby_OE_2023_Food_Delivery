class Order < ApplicationRecord
  enum type_payment: {cod: 0, bank: 1}
  enum status: {processing: 0, confirmed: 1, shipping: 2,
                delivered: 3, canceled: 4}

  has_many :order_items, dependent: :destroy

  belongs_to :user_info
  belongs_to :user

  validates :note, length: {maximum: Settings.digit_255}

  scope :newest, ->{order(created_at: :desc)}
  scope :current_user_orders, ->(user_id){where(user_id:)}

  before_save :set_default_status

  def save_order_code
    update_column :order_code, generate_order_code(id)
  end

  def cancel_order
    update_column :status, :canceled
  end

  def self.ransackable_attributes _auth_object = nil
    %w(created_at id note order_code status total type_payment updated_at
      user_id user_info_id)
  end

  def self.ransackable_associations _auth_object = nil
    %w(order_items user user_info)
  end

  private

  def generate_order_code order_id
    "#KF#{order_id.to_s.rjust(6, '0')}"
  end

  def set_default_status
    self.status ||= :processing
  end
end
