class CreateCities < ActiveRecord::Migration[6.0]
  def change
    create_table :cities do |t|
      t.string :postcode, default: "", null: false
      t.string :name, default: "", null: false
      t.integer :country_code, null: false

      t.timestamps
    end
  end
end
