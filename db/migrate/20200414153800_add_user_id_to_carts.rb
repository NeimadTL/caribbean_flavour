class AddUserIdToCarts < ActiveRecord::Migration[6.0]
  def change
    add_column :carts, :user_id, :integer, null: false
    add_index :carts, :user_id
  end
end
