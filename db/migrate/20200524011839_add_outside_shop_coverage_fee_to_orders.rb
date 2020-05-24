class AddOutsideShopCoverageFeeToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :with_outside_shop_coverage_fee, :boolean, default: false, null: false
    add_column :orders, :outside_shop_coverage_fee, :decimal, default: 0.0, null: false
  end
end
