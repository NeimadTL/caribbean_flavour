require 'rails_helper'

RSpec.describe "consumer/shops/new", type: :view do
  before(:each) do
    assign(:consumer_shop, Consumer::Shop.new())
  end

  it "renders new consumer_shop form" do
    render

    assert_select "form[action=?][method=?]", consumer_shops_path, "post" do
    end
  end
end
