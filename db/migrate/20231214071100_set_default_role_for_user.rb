class SetDefaultRoleForUser < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :role, Settings.role_user
  end
end
