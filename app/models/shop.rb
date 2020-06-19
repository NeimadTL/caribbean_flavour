class Shop < ApplicationRecord

  SORTING_VALUES = {
    0 => 'home_delivery',
    1 => 'all'
  }

  STANDARD_DELIVERY_FEES = 2.5

  validates :name, presence: true, uniqueness: true
  validates :delivery_options, presence: true, unless: -> { delivery_options.count > 0 }
  validates :cities, presence: true, unless: -> { cities.count > 0 }
  validates :phone_number, presence: true
  validates :street, presence: true
  validates :minimum_delivery_price, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :standard_delivery_fees, presence: true,
            numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: STANDARD_DELIVERY_FEES }

  has_many :stocks, dependent: :destroy
  has_many :products, through: :stocks, dependent: :destroy

  has_many :orders, dependent: :destroy

  belongs_to :user

  has_many :shop_delivery_options, dependent: :destroy
  has_many :delivery_options, through: :shop_delivery_options, dependent: :destroy

  belongs_to :product_category, foreign_key: "product_category_code"

  has_many :shop_delivery_coverages, dependent: :destroy
  has_many :cities, through: :shop_delivery_coverages, dependent: :destroy

  belongs_to :country, foreign_key: "country_code"
  belongs_to :city, foreign_key: "city_postcode"

  scope :delivering_in, -> (city_postcode) {
    joins(:shop_delivery_coverages).where("shop_delivery_coverages.city_postcode = '#{city_postcode}'")
  }

end
