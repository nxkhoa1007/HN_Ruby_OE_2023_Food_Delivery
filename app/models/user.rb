class User < ApplicationRecord
  ADDED_ATTRIBUTES = [:name, :email, :password, :password_confirmation,
   :remember_me].freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: {admin: 0, user: 1}
  has_many :orders, dependent: :destroy
  has_many :user_infos, dependent: :destroy
  validates :name, presence: true, length: {maximum: Settings.digit_50}

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
