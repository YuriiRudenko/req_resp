class CreateAccountUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :account_users do |t|
      t.integer :account_id
      t.integer :user_id, index: true

      t.index %i[account_id user_id], unique: true

      t.timestamps
    end
  end
end
