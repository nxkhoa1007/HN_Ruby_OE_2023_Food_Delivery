class SetDefaultStatusProducts < ActiveRecord::Migration[7.0]
  def change
    change_column_default :products, :status, Settings.status_out
  end
end
