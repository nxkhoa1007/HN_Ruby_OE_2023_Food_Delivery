class CreateOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :order_items do |t|
      t.belongs_to :product, null: false, foreign_key: true
      t.belongs_to :order, null: false, foreign_key: true
      t.integer :quantity, null:false
      t.timestamps
    end
    add_index :order_items, [:product_id, :order_id], unique: true
  end
end
