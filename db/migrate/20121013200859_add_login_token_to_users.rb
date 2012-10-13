class AddLoginTokenToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :login_token
      t.boolean :confirmed
    end
    User.all.each do |u|
      u.assign_new_login_token
      u.save
    end
  end
end
