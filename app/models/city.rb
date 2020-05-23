class City < ApplicationRecord

  self.primary_key = 'postcode'

  validates :postcode, presence: true, uniqueness: true, case_sensitive: false
  validates :name, presence: true, uniqueness: true
  validates :country_code, presence: true

  belongs_to :country, foreign_key: "country_code"

  # returns all shops that can deliver in this city
  has_many :shop_delivery_coverages, foreign_key: "city_postcode"
  has_many :coverages, through: :shop_delivery_coverages, class_name: "Shop"

  # returns all localized in this city
  has_many :shops, foreign_key: "city_postcode"
  has_many :users, foreign_key: "city_postcode"

end
