class UserInfo < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :nullify
  validates :name, presence: true, length: {maximum: Settings.digit_255}
  validates :address, presence: true, length: {maximum: Settings.digit_255}
  validates :phoneNum, presence: true, numericality: {only_integer: true},
                       length: {is: Settings.digit_10},
                       format: {with: Regexp.new(Settings.VALID_PHONE_NUM)}
  scope :default_info, ->{where(default_address: true)}
end
