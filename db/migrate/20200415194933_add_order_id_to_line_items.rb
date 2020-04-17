class AddOrderIdToLineItems < ActiveRecord::Migration[6.0]
  def change
    add_column :line_items, :order_id, :integer, null: true
    add_index :line_items, :order_id
  end
end
