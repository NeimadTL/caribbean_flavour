class Order < ApplicationRecord

  STATUS = {
    0 => 'ordered_status',
    1 => 'packed_status',
    2 => 'shipped_status',
    3 => 'delivered_status'
  }

  STANDARD_DELIVERY_FEE = 2.5

  validates :delivery_option_code, presence: true
  validates :status_id, inclusion: { in: STATUS.keys }
  validates :user_id, presence: true
  validates :outside_shop_coverage_fee, numericality: { greater_than_or_equal_to: 1 },
            on: [:update], if: :with_outside_shop_coverage_fee?

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
    total = items_total_price
    if delivery_option_code == (DeliveryOption::CUSTOMER_PLACE_OPTION_CODE || DeliveryOption::PARCEL_PICKUP_POINT_OPTION_CODE)
      total += outside_shop_coverage_fee + STANDARD_DELIVERY_FEE
    end
    total
  end

  def items_total_price
    self.order_line_items.to_a.sum { |item| item.total_price }
  end



  # def to_status
  #   case self.status
  #   when "ordered"
  #     I18n.t('ordered_status')
  #   when "packed"
  #     I18n.t('packed_status')
  #   when "shipped"
  #     I18n.t('shipped_status')
  #   when "delivered"
  #     I18n.t('delivered_status')
  #   end
  # end

end
