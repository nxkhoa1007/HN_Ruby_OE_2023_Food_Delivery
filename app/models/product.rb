class Product < ApplicationRecord
  enum status: {unavailable: 0, available: 1}

  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [
      Settings.digit_150,
      Settings.digit_100
    ]
  end
  validates :name, presence: true, length: {maximum: Settings.digit_50}
  validates :image, content_type:
    {
      in: %w(image/jpeg image/gif image/png),
      message: "must be a valid image format"
    }, size:
    {
      less_than: 5.megabytes,
      message: "should be less than 5MB"
    }
  validates :cost, presence: true, numericality:
    {
      only_integer: true,
      greater_than_or_equal_to: Settings.min_cost,
      less_than_or_equal_to: Settings.max_cost
    }
  validates :description, presence: true,
                       length: {maximum: Settings.digit_255},
                       allow_nil: true
  scope :sort_by_name, ->{order(name: :asc)}
end
