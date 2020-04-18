class AddUserIdToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :user_id, :integer, null: false
    add_index :orders, :user_id
  end
end
