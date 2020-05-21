require 'rails_helper'

RSpec.describe ShopDeliveryCoverage, type: :model do

  it { should belong_to :city }
  it { should belong_to :shop }

end
