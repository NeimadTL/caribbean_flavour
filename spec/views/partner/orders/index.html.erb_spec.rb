require 'rails_helper'

RSpec.describe "partner/orders/index", type: :view do
  before(:each) do
    assign(:partner_orders, [
      Partner::Order.create!(),
      Partner::Order.create!()
    ])
  end

  it "renders a list of partner/orders" do
    render
  end
end
