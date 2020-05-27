class RenameWithOutsideShopCoverageFeeIntoOcdToOrders < ActiveRecord::Migration[6.0]
  def change
    rename_column :orders, :with_outside_shop_coverage_fee, :is_ocd
  end
end

# OCD stands for Outside Coverage Delivery
