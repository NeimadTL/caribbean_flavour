require 'rails_helper'

RSpec.describe Stock, type: :model do

  it { should validate_presence_of(:price).on(:create).on(:update) }
  it { should validate_numericality_of(:price).is_greater_than(0) }
  it { should validate_presence_of :shop_id }

  it { should belong_to :product }
  it { should belong_to :shop }

  it { should have_many :line_items }

end
