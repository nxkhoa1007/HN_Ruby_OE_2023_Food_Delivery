class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true
  scope :unread_noti, ->{where(read_at: nil)}
  scope :newest, ->{order(created_at: :desc)}
end
