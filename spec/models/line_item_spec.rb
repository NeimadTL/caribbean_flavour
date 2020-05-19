require 'rails_helper'

RSpec.describe LineItem, type: :model do

  it { should validate_presence_of :stock_id }
  it { should validate_presence_of(:quantity) }
  it { should validate_numericality_of(:quantity).only_integer.is_greater_than(0) }

  it { should belong_to(:cart).optional }
  it { should belong_to :stock }

end
