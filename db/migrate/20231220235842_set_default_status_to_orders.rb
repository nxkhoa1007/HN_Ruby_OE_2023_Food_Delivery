class SetDefaultStatusToOrders < ActiveRecord::Migration[7.0]
  def change
    change_column_default :orders, :status, Settings.status_out
  end
end
