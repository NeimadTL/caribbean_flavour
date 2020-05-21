class ShopDeliveryCoverage < ApplicationRecord

  belongs_to :city, foreign_key: "city_postcode"
  belongs_to :shop
  
end
