class SetDefaultAddressUserInfo < ActiveRecord::Migration[7.0]
  def change
    change_column_default :user_infos, :default_address, 0
  end
end
