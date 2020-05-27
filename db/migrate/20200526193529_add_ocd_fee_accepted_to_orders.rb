class AddOcdFeeAcceptedToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :ocd_fee_accepted, :boolean, default: false, null: false
  end
end
