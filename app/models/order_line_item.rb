class OrderLineItem < ApplicationRecord

  validates :name, presence: true
  validates :unit_price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates_presence_of :order
  
  belongs_to :order, inverse_of: :order_line_items

  def total_price
    self.unit_price * self.quantity
  end
end
