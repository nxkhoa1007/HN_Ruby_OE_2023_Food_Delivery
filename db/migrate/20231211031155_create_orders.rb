class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :order_code
      t.integer :type_payment
      t.integer :status
      t.string :note
      t.integer :total
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
