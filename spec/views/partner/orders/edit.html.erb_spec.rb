require 'rails_helper'

RSpec.describe "partner/orders/edit", type: :view do
  before(:each) do
    @partner_order = assign(:partner_order, Partner::Order.create!())
  end

  it "renders the edit partner_order form" do
    render

    assert_select "form[action=?][method=?]", partner_order_path(@partner_order), "post" do
    end
  end
end
