class RemoveCityNPostcodeNCountry < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :country, :string
    remove_column :users, :city, :string
    remove_column :users, :postcode, :string
  end
end
