class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :cost
      t.integer :status
      t.integer :sold
      t.timestamps
    end
  end
end
