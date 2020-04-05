require 'rails_helper'

RSpec.describe ShopDeliveryOption, type: :model do

  it { should belong_to :delivery_option }
  it { should belong_to :shop }

end
