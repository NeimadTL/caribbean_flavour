class DeliveryOption < ApplicationRecord

  self.primary_key = 'code'

  CUSTOMER_PLACE_OPTION_CODE = 1
  SHOP_OWNER_PLACE_OPTION_CODE = 2
  PARCEL_PICKUP_POINT_OPTION_CODE = 3
  MARKET_PLACE_OPTION_CODE = 4

  validates :code, presence: true
  validates :option, presence: true, uniqueness: true

  has_many :shop_delivery_options, foreign_key: "delivery_option_code"
  has_many :shops, through: :shop_delivery_options

  def to_option
    case self.code
    when CUSTOMER_PLACE_OPTION_CODE
      I18n.t('customer_place')
    when SHOP_OWNER_PLACE_OPTION_CODE
      I18n.t('shop_owner_place')
    when PARCEL_PICKUP_POINT_OPTION_CODE
      I18n.t('parcel_pickup_point')
    when MARKET_PLACE_OPTION_CODE
      I18n.t('market_place')
    end
  end

end
