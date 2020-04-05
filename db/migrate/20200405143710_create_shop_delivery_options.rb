class CreateShopDeliveryOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :shop_delivery_options do |t|
      t.integer :shop_id, null: false
      t.integer :delivery_option_code, default: "", null: false

      t.timestamps
    end

    add_index :shop_delivery_options, :shop_id
    add_index :shop_delivery_options, :delivery_option_code
    add_index :shop_delivery_options, [:shop_id, :delivery_option_code]
  end
end
