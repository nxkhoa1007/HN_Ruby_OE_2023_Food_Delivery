class AddCostToOrderItem < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :cost, :integer
  end
end
