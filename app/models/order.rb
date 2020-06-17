class Order < ApplicationRecord

  STATUS = {
    0 => 'ordered_status',
    1 => 'packed_status',
    2 => 'shipped_status',
    3 => 'delivered_status'
  }

  validates :delivery_option_code, presence: true
  validates :status_id, inclusion: { in: STATUS.keys }
  validates :user_id, presence: true

  has_many :order_line_items, dependent: :destroy
  belongs_to :user
  belongs_to :delivery_option, foreign_key: "delivery_option_code"


  def add_line_item(items)
    items.each do |item|
      item = self.order_line_items.build(name: item.stock.product.name,
                                           unit_price: item.stock.price,
                                           quantity: item.quantity,
                                           shop_id: item.stock.shop.id)
    end
  end

  def shop
    Shop.find(self.order_line_items.first.shop_id)
  end

  def total_price
    total = self.order_line_items.to_a.sum { |item| item.total_price }
    if self.delivery_option_code == DeliveryOption::CUSTOMER_PLACE_OPTION_CODE && self.shop.standard_delivery_fees > 0
      total += self.shop.standard_delivery_fees
    end
    total
  end

  def items_total_price
    self.order_line_items.to_a.sum { |item| item.total_price }
  end

end
