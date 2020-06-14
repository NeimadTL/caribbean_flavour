class Product < ApplicationRecord

  self.primary_key = 'reference'

  ICONS = {
    "poyo_ref" => "green_banana.png",
    "igname_ref" => "yam.jpeg",
    "banana_ref" => "yellow_banana.png"
  }
  ICONS.default = "no_image_available.png"

  validates :reference, presence: true, uniqueness: true
  validates :name, presence: true
  validates :product_category_id, presence: true

  belongs_to :product_category

  has_many :stocks, foreign_key: "product_reference"
  has_many :shops, through: :stocks

end
