class Cart < ApplicationRecord

  has_many :line_items
  belongs_to :user

  def total_price
    self.line_items.to_a.sum { |item| item.total_price }
  end

  def line_items_by_shop
    self.line_items.group_by { |item| item.stock.shop }
  end

  def total_price_by_shop(items)
    items.sum { |item| item.total_price }
  end

  def line_items_of(shop)
    self.line_items.select { |item| item.stock.shop.id == shop.id }
  end
  
end
