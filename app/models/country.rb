class Country < ApplicationRecord

  validates :code, presence: true, uniqueness: true, case_sensitive: false
  validates :name, presence: true, uniqueness: true

  has_many :cities, foreign_key: "country_code"

end
