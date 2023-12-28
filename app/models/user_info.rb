class UserInfo < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :restrict_with_error
  validates :name, presence: true, length: {maximum: Settings.digit_255}
  validates :address, presence: true, length: {maximum: Settings.digit_255}
  validates :phoneNum, presence: true, numericality: {only_integer: true},
                       length: {is: Settings.digit_10},
                       format: {with: Regexp.new(Settings.VALID_PHONE_NUM)}
  scope :default_info, ->{where(default_address: true)}
  scope :default_info_list, ->{order(default_address: :desc)}

  before_create :set_default

  def set_as_default
    UserInfo.transaction do
      user.user_infos.update_all(default_address: false)
      update(default_address: true)
    rescue StandardError => e
      Rails.logger.error("Error: #{e.message}")
    end
  end

  private

  def set_default
    return unless user.user_infos.count == Settings.digit_0

    self.default_address = true
  end
end
