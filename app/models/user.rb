class User < ApplicationRecord
  enum gender: {male: 0, female: 1, other: 2}
  enum role: {admin: 0, user: 1}
  has_many :orders, dependent: :destroy
end
