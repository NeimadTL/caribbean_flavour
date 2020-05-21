class CreateShopDeliveryCoverages < ActiveRecord::Migration[6.0]
  def change
    create_table :shop_delivery_coverages do |t|
      t.integer :shop_id, null: false
      t.integer :city_postcode, null: false

      t.timestamps
    end
    
    add_index :shop_delivery_coverages, :shop_id
    add_index :shop_delivery_coverages, :city_postcode
    add_index :shop_delivery_coverages, [:shop_id, :city_postcode], unique: true
  end
end
