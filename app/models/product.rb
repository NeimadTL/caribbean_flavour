class Product < ApplicationRecord

  self.primary_key = 'reference'

  validates :reference, presence: true, uniqueness: true
  validates :name, presence: true

  belongs_to :product_category

  has_many :stocks, foreign_key: "product_reference"
  has_many :shops, through: :stocks

end
