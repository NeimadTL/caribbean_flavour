class ShopDeliveryOption < ApplicationRecord

  belongs_to :delivery_option, foreign_key: "delivery_option_code"
  belongs_to :shop
  
end
