class ChangeCountryCodeTypeIntoStringInCities < ActiveRecord::Migration[6.0]
  def change
    change_column :cities, :country_code, :string
  end
end
