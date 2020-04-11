class LineItem < ApplicationRecord

  validates :cart_id, presence: true
  validates :stock_id, presence: true, uniqueness: true
  validates :quantity, presence: true

  belongs_to :cart
  belongs_to :stock

end
