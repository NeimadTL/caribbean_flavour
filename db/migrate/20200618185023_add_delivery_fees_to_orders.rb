class AddDeliveryFeesToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :standard_delivery_fees, :decimal, default: 0.0, null: false
  end
end
