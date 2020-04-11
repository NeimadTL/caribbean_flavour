require 'rails_helper'

RSpec.describe LineItem, type: :model do

  it { should validate_presence_of :cart_id }
  it { should validate_presence_of :stock_id }
  it { should validate_uniqueness_of :stock_id }
  it { should validate_presence_of :quantity }

  it { should belong_to :cart }
  it { should belong_to :stock }

end
