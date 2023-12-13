class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :products, dependent: :restrict_with_error

  scope :sort_by_name, ->{order(name: :asc)}

  private

  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
