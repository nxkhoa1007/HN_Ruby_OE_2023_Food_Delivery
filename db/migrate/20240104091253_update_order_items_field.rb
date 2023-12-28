class UpdateOrderItemsField < ActiveRecord::Migration[7.0]
  def change
    add_column :order_items, :rated, :boolean, default: false
  end
end
