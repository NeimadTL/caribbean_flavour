module Priceable
  extend ActiveSupport::Concern

  def total_price_for(items)
    items.sum { |item| item.total_price }
  end

end
