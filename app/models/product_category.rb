class ProductCategory < ApplicationRecord

  self.primary_key = 'code'

  FARMING_CATEGORY_CODE = 1
  FISHING_CATEGORY_CODE = 2
  CATERING_CATEGORY_CODE = 3

  validates :code, presence: true
  validates :name, presence: true, uniqueness: true

  has_one :product
  
end
