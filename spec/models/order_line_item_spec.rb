require 'rails_helper'

RSpec.describe OrderLineItem, type: :model do

  it { should belong_to :order }
  it { should belong_to :shop }

end
