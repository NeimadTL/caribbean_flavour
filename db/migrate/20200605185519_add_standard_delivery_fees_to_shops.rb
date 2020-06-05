class AddStandardDeliveryFeesToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :standard_delivery_fees, :decimal, default: 0.0, null: false
  end
end
