class Stock < ApplicationRecord

  belongs_to :product, foreign_key: "product_reference"
  belongs_to :shop

  scope :price_of, -> (product, shop) {
    where(product_reference: product.reference, shop_id: shop.id).first.price
  }

end
