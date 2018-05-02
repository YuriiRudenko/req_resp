class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :uuid, null: false

      t.string :name,          null: false
      t.string :sortable_name, null: false

      t.integer :workflow_state, null: false

      t.timestamps

      t.index :uuid
    end
  end
end
