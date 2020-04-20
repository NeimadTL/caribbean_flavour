require 'rails_helper'

RSpec.describe "partner/orders/new", type: :view do
  before(:each) do
    assign(:partner_order, Partner::Order.new())
  end

  it "renders new partner_order form" do
    render

    assert_select "form[action=?][method=?]", partner_orders_path, "post" do
    end
  end
end
