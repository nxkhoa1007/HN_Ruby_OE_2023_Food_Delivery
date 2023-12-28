class Product < ApplicationRecord
  extend FriendlyId

  friendly_id :name, use: :slugged

  enum status: {unavailable: 0, available: 1}

  before_validation :remove_commas_from_price

  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_many :ratings, dependent: :destroy
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
  validates :image, presence: true, content_type:
    {
      in: %w(image/jpeg image/gif image/png),
      message: I18n.t("text.image_format")
    }, size:
    {
      less_than: Settings.digit_5.megabytes,
      message: I18n.t("text.image_size")
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

  def self.ransackable_attributes _auth_object = nil
    %w(category_id cost created_at description id name slug sold status
    updated_at)
  end

  def self.ransackable_associations _auth_object = nil
    %w(category image_attachment image_blob order_items)
  end

  private

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  def remove_commas_from_price
    self.cost = cost_before_type_cast.gsub(",", "").to_i if cost.present?
  end
end
