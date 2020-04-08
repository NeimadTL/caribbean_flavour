class AddIndexesToStocks < ActiveRecord::Migration[6.0]
  def change
    add_index :stocks, :product_reference
    add_index :stocks, :shop_id
    add_index :stocks, [:product_reference, :shop_id], unique: true
  end
end
