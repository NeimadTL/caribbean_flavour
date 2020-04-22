class OrderLineItem < ApplicationRecord

  belongs_to :order
  belongs_to :shop

  def total_price
    self.unit_price * self.quantity
  end
end
