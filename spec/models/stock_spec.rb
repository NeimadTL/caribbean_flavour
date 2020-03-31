require 'rails_helper'

RSpec.describe Stock, type: :model do

  it { should belong_to :product }
  it { should belong_to :shop }

end
