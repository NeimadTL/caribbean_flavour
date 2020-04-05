require 'rails_helper'

RSpec.describe DeliveryOption, type: :model do

  it { should validate_presence_of :code }
  it { should validate_presence_of :option }

  describe "option uniqueness validation" do
    subject { DeliveryOption.create(code: 0, option: "Customer's place") }
    it { should validate_uniqueness_of(:option) }
  end

  it { should have_many :shop_delivery_options }
  it { should have_many :shops }

end
