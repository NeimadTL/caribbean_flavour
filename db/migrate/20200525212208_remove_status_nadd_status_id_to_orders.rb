class RemoveStatusNaddStatusIdToOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :status, :string
    add_column :orders, :status_id, :integer, default: 0, null: false
  end
end
