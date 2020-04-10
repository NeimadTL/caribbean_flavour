require 'rails_helper'

RSpec.describe Stock, type: :model do

  it { should validate_presence_of :product_reference }
  describe "product_reference uniqueness validation" do
    subject { Stock.create(shop_id: 2, product_reference: 'ref') }
    it { should validate_uniqueness_of(:product_reference) }
  end

  it { should validate_presence_of :shop_id }

  it { should belong_to :product }
  it { should belong_to :shop }

  it { should have_many :line_items }

end
