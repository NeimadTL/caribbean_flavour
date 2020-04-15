class LineItem < ApplicationRecord

  validates :cart_id, presence: true
  validates :stock_id, presence: true
  validates :quantity, presence: true

  belongs_to :cart
  belongs_to :stock

  def price
    self.stock.price
  end

  def total_price
    self.price * self.quantity
  end

end
