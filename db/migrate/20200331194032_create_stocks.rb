class CreateStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.integer :shop_id, null: false
      t.string :product_reference, default: "", null: false
      t.decimal :price, default: 0.0, null: false

      t.timestamps
    end
  end
end
