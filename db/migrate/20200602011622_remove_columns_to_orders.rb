class RemoveColumnsToOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :is_ocd, :boolean
    remove_column :orders, :ocd_fee, :decimal
    remove_column :orders, :ocd_fee_accepted, :boolean
  end
end
