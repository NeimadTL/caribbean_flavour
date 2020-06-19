require 'rails_helper'

RSpec.describe Order, type: :model do

  it { should validate_presence_of :delivery_option_code }
  it { should validate_inclusion_of(:status_id).in_array(Order::STATUS.keys) }
  it { should validate_presence_of :user_id }

  it { should have_many :order_line_items }
  it { should belong_to :user }
  it { should belong_to :shop }
  it { should belong_to :delivery_option }

end
