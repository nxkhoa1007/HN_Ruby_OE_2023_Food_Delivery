class AddDefaltAddressToUserInfo < ActiveRecord::Migration[7.0]
  def change
    add_column :user_infos, :default_address, :boolean
  end
end
