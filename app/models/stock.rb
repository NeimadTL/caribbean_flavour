class Stock < ApplicationRecord

  validates_associated :product, on: [:create, :update]
  validates :price, presence: true, on: [:create, :update]
  validates :shop_id, presence: true

  belongs_to :product, foreign_key: "product_reference"
  belongs_to :shop

  has_many :line_items

end
