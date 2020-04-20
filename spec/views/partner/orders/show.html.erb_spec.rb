require 'rails_helper'

RSpec.describe "partner/orders/show", type: :view do
  before(:each) do
    @partner_order = assign(:partner_order, Partner::Order.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
