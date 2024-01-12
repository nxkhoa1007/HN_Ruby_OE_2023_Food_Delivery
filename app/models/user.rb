class User < ApplicationRecord
  ADDED_ATTRIBUTES = [:name, :email, :password, :password_confirmation,
   :remember_me].freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum role: {admin: 0, user: 1}
  has_many :ratings, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :user_infos, dependent: :destroy

  has_one_attached :avatar do |attachable|
    attachable.variant :display, resize_to_limit: [
      Settings.digit_25,
      Settings.digit_25
    ]
    attachable.variant :user_info, resize_to_limit: [
      Settings.digit_150,
      Settings.digit_150
    ]
    attachable.variant :comment, resize_to_limit: [
      Settings.digit_50,
      Settings.digit_50
    ]
  end

  validates :name, presence: true, length: {maximum: Settings.digit_50}
  scope :admin_user, ->{where(role: :admin)}

  before_save :downcase_email
  before_create :default_avatar

  def update_password params
    current_password = params.delete(:current_password)
    result = if valid_password?(current_password)
               update(params)
             else
               assign_attributes(params)
               valid?
               errors.add(:current_password,
                          current_password.blank? ? :blank : :invalid)
               false
             end
    clean_up_passwords
    result
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private

  def downcase_email
    email.downcase!
  end

  def default_avatar
    image_file = URI.parse(Settings.default_avatar).open
    avatar.attach(io: image_file,
                  filename: "image.jpg", content_type: "image/jpeg")
  end
end
