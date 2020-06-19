require 'rails_helper'

RSpec.describe OrderLineItem, type: :model do

  it { should validate_presence_of :name }
  it { should validate_presence_of :unit_price }
  it { should validate_numericality_of(:unit_price).is_greater_than(0) }
  it { should validate_presence_of :quantity }
  it { should validate_numericality_of(:quantity).only_integer.is_greater_than(0) }

  it { should validate_presence_of :order }

  it { should belong_to(:order).inverse_of(:order_line_items) }

end
