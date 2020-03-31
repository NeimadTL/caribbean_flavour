class Stock < ApplicationRecord

  belongs_to :product, foreign_key: "product_reference"
  belongs_to :shop

end
