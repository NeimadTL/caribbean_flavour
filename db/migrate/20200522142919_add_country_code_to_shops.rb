class AddCountryCodeToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :country_code, :string, null: false
    add_index :shops, :country_code
  end
end
