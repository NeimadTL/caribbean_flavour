class AddAddressDetailsToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :phone_number, :string, default: "", null: false
    add_column :shops, :street, :string, default: "", null: false
    add_column :shops, :additional_address_information, :string, default: ""
    add_column :shops, :city_postcode, :string, null: false
    add_index :shops, :city_postcode
  end
end
