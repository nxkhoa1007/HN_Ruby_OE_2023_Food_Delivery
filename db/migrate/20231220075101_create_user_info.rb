class CreateUserInfo < ActiveRecord::Migration[7.0]
  def change
    create_table :user_infos do |t|
      t.string :name
      t.string :address
      t.string :phoneNum
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
