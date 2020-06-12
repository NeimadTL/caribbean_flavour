class OrderLineItem < ApplicationRecord

  validates :name, presence: true
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # validates :order_id, presence: true
  validates :shop_id, presence: true

  belongs_to :order
  belongs_to :shop

  def total_price
    self.unit_price * self.quantity
  end
end
