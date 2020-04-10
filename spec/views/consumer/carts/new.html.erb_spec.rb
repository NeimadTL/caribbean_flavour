require 'rails_helper'

RSpec.describe "consumer/carts/new", type: :view do
  before(:each) do
    assign(:consumer_cart, Consumer::Cart.new())
  end

  it "renders new consumer_cart form" do
    render

    assert_select "form[action=?][method=?]", consumer_carts_path, "post" do
    end
  end
end
