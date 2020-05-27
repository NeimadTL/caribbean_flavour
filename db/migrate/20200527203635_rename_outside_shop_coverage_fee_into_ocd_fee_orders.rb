class RenameOutsideShopCoverageFeeIntoOcdFeeOrders < ActiveRecord::Migration[6.0]
  def change
    rename_column :orders, :outside_shop_coverage_fee, :ocd_fee
  end
end

# OCD stands for Outside Coverage Delivery
