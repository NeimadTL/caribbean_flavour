class CreateLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :line_items do |t|
      t.integer :cart_id, null: false
      t.integer :stock_id, null: false
      t.integer :quantity, default: 0, null: false

      t.timestamps
    end

    add_index :line_items, :cart_id
    add_index :line_items, :stock_id
    add_index :line_items, [:cart_id, :stock_id], unique: true
  end
end
