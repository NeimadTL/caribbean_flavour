class Stock < ApplicationRecord

  validate :presence_of_product_reference, on: [:create, :update]
  validate :presence_of_price, on: [:create, :update]
  validates :shop_id, presence: true

  belongs_to :product, foreign_key: "product_reference"
  belongs_to :shop

  has_many :line_items

  private

    def presence_of_product_reference
      if product_reference.blank?
        errors[:base] << "#{I18n.t('.blank_product_ref_error')}"
      end
    end

    def presence_of_price
      if price.blank?
        errors[:base] << "#{I18n.t('.blank_price_error')}"
      end
    end

end
