require 'rails_helper'

RSpec.describe "products/index", type: :view do
  before(:each) do
    assign(:products, [
      Product.create!(),
      Product.create!()
    ])
  end

  xit "renders a list of products" do
    render
  end
end
