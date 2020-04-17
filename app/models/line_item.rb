class LineItem < ApplicationRecord

  validates :stock_id, presence: true
  validates :quantity, presence: true

  belongs_to :cart,optional: true
  belongs_to :stock
  belongs_to :order, optional: true

  def price
    self.stock.price
  end

  def total_price
    self.price * self.quantity
  end

end
