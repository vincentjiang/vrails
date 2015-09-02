class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :username
      t.string :password_digest
      t.boolean :admin, default: false
      t.datetime :last_login_time
      t.string :avatar
      t.boolean :activation, default: false

      t.timestamps null: false
    end
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end
end
