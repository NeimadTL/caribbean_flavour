require 'rails_helper'

RSpec.describe LineItem, type: :model do

  it { should validate_presence_of :stock_id }
  it { should validate_presence_of :quantity }

  it { should belong_to(:cart).optional }
  it { should belong_to :stock }
  
end
