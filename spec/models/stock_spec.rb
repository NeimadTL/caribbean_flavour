require 'rails_helper'

RSpec.describe Stock, type: :model do

  it { should validate_presence_of :shop_id }

  it { should belong_to :product }
  it { should belong_to :shop }

  it { should have_many :line_items }

end
