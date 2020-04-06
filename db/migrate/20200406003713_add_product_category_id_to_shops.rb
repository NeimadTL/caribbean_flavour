class AddProductCategoryIdToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :product_category_code, :integer, null: false
    add_index :shops, :product_category_code
  end
end
