class AddUserInfoToOrder < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :user_info, foreign_key: true
  end
end
