class Order < ApplicationRecord

  STATUS = ["ordered", "packed", "shipped", "delivered"]

  validates :delivery_option_code, presence: true
  validates :status, inclusion: { in: STATUS }
  validates :user_id, presence: true

  has_many :order_line_items, dependent: :destroy
  belongs_to :user
  belongs_to :delivery_option, foreign_key: "delivery_option_code"

  def add_line_item(items)
    items.each do |item|
      saved = self.order_line_items.create(name: item.stock.product.name,
                                           unit_price: item.stock.price,
                                           quantity: item.quantity,
                                           shop_id: item.stock.shop.id)
      item.delete if saved
    end
  end

  def shop
    Shop.find(self.order_line_items.first.shop_id)
  end

  def total_price
    self.order_line_items.to_a.sum { |item| item.total_price }
  end

end
