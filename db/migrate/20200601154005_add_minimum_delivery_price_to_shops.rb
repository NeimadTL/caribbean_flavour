class AddMinimumDeliveryPriceToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :minimum_delivery_price, :integer, default: 0, null: false
  end
end
