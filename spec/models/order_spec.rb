require 'rails_helper'

RSpec.describe Order, type: :model do

  it { should validate_presence_of :delivery_option_code }
  it { should validate_inclusion_of(:status_id).in_array(Order::STATUS.keys) }
  it { should validate_presence_of :user_id }
  context "if order.is_ocd?" do
    before do allow(subject).to receive(:is_ocd?).and_return(true)
      it { should validate_numericality_of(:ocd_fee).is_greater_than_or_equal_to(1).on(:update) }
    end
  end
  
  it { should have_many :order_line_items }
  it { should belong_to :user }

end
