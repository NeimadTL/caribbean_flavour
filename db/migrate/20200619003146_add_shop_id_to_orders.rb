class AddShopIdToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :shop_id, :integer, null: false
    add_index :orders, :shop_id
  end
end
