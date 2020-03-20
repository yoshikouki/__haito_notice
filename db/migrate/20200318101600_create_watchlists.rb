class CreateWatchlists < ActiveRecord::Migration[5.1]
  def change
    create_table :watchlists do |t|
      t.integer :user_id
      t.integer :local_code

      t.timestamps
    end
    add_index :watchlists, :user_id
    add_index :watchlists, :local_code
    add_index :watchlists, [:user_id, :local_code], unique: true
  end
end
