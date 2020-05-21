class City < ApplicationRecord

  self.primary_key = 'postcode'

  validates :postcode, presence: true, uniqueness: true, case_sensitive: false
  validates :name, presence: true, uniqueness: true
  validates :country_code, presence: true

  belongs_to :country, foreign_key: "country_code"

  has_many :shop_delivery_coverages, foreign_key: "city_postcode"
  has_many :shops, through: :shop_delivery_coverages

end
