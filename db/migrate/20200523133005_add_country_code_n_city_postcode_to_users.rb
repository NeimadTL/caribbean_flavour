class AddCountryCodeNCityPostcodeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :country_code, :string, default: "", null: false
    add_column :users, :city_postcode, :string, default: "", null: false
    add_index :users, :country_code
    add_index :users, :city_postcode
  end
end
