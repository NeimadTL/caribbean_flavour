require 'rails_helper'

RSpec.describe "consumer/carts/show", type: :view do
  before(:each) do
    @consumer_cart = assign(:consumer_cart, Consumer::Cart.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
