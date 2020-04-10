require 'rails_helper'

RSpec.describe "consumer/carts/index", type: :view do
  before(:each) do
    assign(:consumer_carts, [
      Consumer::Cart.create!(),
      Consumer::Cart.create!()
    ])
  end

  it "renders a list of consumer/carts" do
    render
  end
end
