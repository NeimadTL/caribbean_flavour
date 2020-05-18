class OrderLineItem < ApplicationRecord

  validates :order_id, presence: true
  validates :shop_id, presence: true

  belongs_to :order
  belongs_to :shop

  def total_price
    self.unit_price * self.quantity
  end
end
