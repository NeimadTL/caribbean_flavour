class AddIndexesToOrderLineItems < ActiveRecord::Migration[6.0]
  def change
    add_index :order_line_items, :shop_id
    add_index :order_line_items, :order_id
  end
end
