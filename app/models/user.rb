class User < ApplicationRecord
  attr_accessor :activation_token, :remember_token

  ADDED_ATTRIBUTES = [:name, :email, :password, :password_confirmation,
   :remember_me].freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: {admin: 0, user: 1}
  has_many :orders, dependent: :destroy
  has_many :user_infos, dependent: :destroy
  validates :name, presence: true, length: {maximum: Settings.digit_50}

  before_save :downcase_email
  before_create :create_activation_digest

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine.min_cost
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost => cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? attributed, token
    digest = send "#{attributed}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_column :remember_digest, nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
