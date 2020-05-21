class City < ApplicationRecord

  validates :postcode, presence: true, uniqueness: true, case_sensitive: false 
  validates :name, presence: true, uniqueness: true
  validates :country_code, presence: true

end
