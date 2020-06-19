class RemoveShopIdFromOrderLineItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :order_line_items, :shop_id
  end
end
