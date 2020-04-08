require 'rails_helper'

RSpec.describe "consumer/shops/index", type: :view do
  before(:each) do
    assign(:consumer_shops, [
      Consumer::Shop.create!(),
      Consumer::Shop.create!()
    ])
  end

  it "renders a list of consumer/shops" do
    render
  end
end
