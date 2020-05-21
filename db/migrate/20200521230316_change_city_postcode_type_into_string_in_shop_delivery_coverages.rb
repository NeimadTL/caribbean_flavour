class ChangeCityPostcodeTypeIntoStringInShopDeliveryCoverages < ActiveRecord::Migration[6.0]
  def change
    change_column :shop_delivery_coverages, :city_postcode, :string
  end
end
