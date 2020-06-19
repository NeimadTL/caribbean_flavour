class AddProductReferenceToOrderLineItems < ActiveRecord::Migration[6.0]
  def change
    add_column :order_line_items, :product_reference, :string, default: "", null: false
  end
end
