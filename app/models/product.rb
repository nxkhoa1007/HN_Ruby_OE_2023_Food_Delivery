class Product < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  enum status: {unavailable: 0, available: 1}

  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [
      Settings.digit_150,
      Settings.digit_100
    ]
    attachable.variant :display_user, resize_to_limit: [
      Settings.digit_450,
      Settings.digit_300
    ]
    attachable.variant :display_user_info, resize_to_limit: [
      Settings.digit_600,
      Settings.digit_600
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
  scope :exclude_current, ->(id){where.not(id:)}
  scope :newest, ->{order(created_at: :desc)}
  scope :best_sellers, ->{order(sold: :desc)}
  scope :price_desc, ->{order(cost: :desc)}
  scope :price_asc, ->{order(cost: :asc)}
  scope :search_by_name, ->(query){where("name LIKE ?", "%#{query}%")}

  private

  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
