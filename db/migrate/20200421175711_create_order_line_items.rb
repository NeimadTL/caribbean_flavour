class CreateOrderLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_line_items do |t|
      t.string :name, default: "", null: false
      t.decimal :unit_price, default: 0.0, null: false
      t.integer :quantity, default: 0.0, null: false
      t.integer :shop_id, null: false
      t.integer :order_id, null: false

      t.timestamps
    end
  end
end
