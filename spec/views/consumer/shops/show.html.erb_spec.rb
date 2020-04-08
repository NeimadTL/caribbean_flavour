require 'rails_helper'

RSpec.describe "consumer/shops/show", type: :view do
  before(:each) do
    @consumer_shop = assign(:consumer_shop, Consumer::Shop.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
