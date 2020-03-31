class Product < ApplicationRecord

  self.primary_key = 'reference'

  validates :reference, presence: true, uniqueness: true
  validates :name, presence: true

  belongs_to :product_category

end
