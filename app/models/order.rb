class Order < ApplicationRecord

  validates :delivery_option_code, presence: true

  has_many :line_items, dependent: :destroy
  belongs_to :user

  def add_line_item(items)
    items.each do |item|
      item.cart_id = nil
      self.line_items << item
    end
  end

  def shop
    self.line_items.first.stock.shop
  end

  def total_price
    self.line_items.to_a.sum { |item| item.total_price }
  end

end
