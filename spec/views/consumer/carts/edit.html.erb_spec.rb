require 'rails_helper'

RSpec.describe "consumer/carts/edit", type: :view do
  before(:each) do
    @consumer_cart = assign(:consumer_cart, Consumer::Cart.create!())
  end

  it "renders the edit consumer_cart form" do
    render

    assert_select "form[action=?][method=?]", consumer_cart_path(@consumer_cart), "post" do
    end
  end
end
