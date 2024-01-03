class DeleteFieldsUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :password_digest, :string, null: false
    remove_column :users, :gender, :string
    remove_column :users, :phoneNum, :string, null: false
    remove_column :users, :address, :string, null: false
    remove_column :users, :dob, :date, null: false
    remove_column :users, :activated, :boolean, null: false
    remove_column :users, :remember_digest, :string, null: false
    remove_column :users, :activation_digest, :string, null: false
    remove_column :users, :activated_at, :datetime, null: false
  end
end
