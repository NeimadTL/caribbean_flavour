require 'rails_helper'

RSpec.describe "consumer/shops/edit", type: :view do
  before(:each) do
    @consumer_shop = assign(:consumer_shop, Consumer::Shop.create!())
  end

  it "renders the edit consumer_shop form" do
    render

    assert_select "form[action=?][method=?]", consumer_shop_path(@consumer_shop), "post" do
    end
  end
end
