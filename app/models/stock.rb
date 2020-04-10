class Stock < ApplicationRecord

  validates :product_reference, presence: true, uniqueness: true
  validates :shop_id, presence: true

  belongs_to :product, foreign_key: "product_reference"
  belongs_to :shop

  has_many :line_items

end
