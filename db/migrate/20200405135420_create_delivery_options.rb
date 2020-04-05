class CreateDeliveryOptions < ActiveRecord::Migration[6.0]
  def change
    create_table :delivery_options do |t|
      t.integer :code, null: false
      t.string :option, default: "", null: false

      t.timestamps
    end
  end
end
