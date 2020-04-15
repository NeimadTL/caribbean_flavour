class Cart < ApplicationRecord

  has_many :line_items
  belongs_to :user

  def total_price
    self.line_items.to_a.sum { |item| item.total_price }
  end

end
