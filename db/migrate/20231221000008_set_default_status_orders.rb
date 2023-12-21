class SetDefaultStatusOrders < ActiveRecord::Migration[7.0]
  def change
    change_column_default :orders, :status, Settings.digit_0
  end
end
