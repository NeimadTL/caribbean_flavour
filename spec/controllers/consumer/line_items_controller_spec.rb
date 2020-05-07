require 'rails_helper'

RSpec.describe Consumer::LineItemsController, type: :controller do

  let(:consumer) {
    User.create!(username: "consu", firstname: "consu_firstname", lastname: "consu_lastname",
    city: "city", email: "consu@gmail.com", phone_number: "0394274839", street: "street",
    additional_address_information: "additional address", postcode: "97119",
    country: "country", is_partner: false, role_code: Role::CONSUMER_ROLE_CODE,
    password: "12345678", password_confirmation: "12345678")
  }

  let(:another_consumer) {
    User.create!(username: "another_consu", firstname: "another_consu_firstname",
    lastname: "another_consu_lastname", city: "city", email: "another_consu@gmail.com",
    phone_number: "0394274839", street: "street", additional_address_information: "additional address",
    postcode: "97119",country: "country", is_partner: false, role_code: Role::CONSUMER_ROLE_CODE,
    password: "12345678", password_confirmation: "12345678")
  }

  let(:partner) {
    User.create!(username: "partner", firstname: "partner_firstname", lastname: "partner_lastname",
    city: "city", email: "partner@gmail.com", phone_number: "0394274839", street: "street",
    additional_address_information: "additional address", postcode: "97119",
    country: "country", is_partner: false, role_code: Role::PARTNER_ROLE_CODE,
    password: "12345678", password_confirmation: "12345678")
  }

  let(:shop_attributes) {
    { name: 'new shop', product_category_code: 1, delivery_option_ids: [1, 2] }
  }

  let(:product) {
    Product.create!(reference: 'dummy_ref', name: 'dummy_product', product_category_id: ProductCategory::FARMING_CATEGORY_CODE)
  }

  let(:valid_attributes) {
    { product_reference: product.reference, price: 2.2 }
  }

  let(:invalid_attributes) {
    { delivery_option_code: "" }
  }

  let(:valid_session) { {} }

  describe "GET #new" do
    context "when partner is signed in" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a success response" do
        stock_id = partner.shop.stocks.first.id
        get :new, params: {cart_id: consumer.cart.id, stock_id: stock_id}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when consumer tries to add a product for another one consumer" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a success response" do
        stock_id = partner.shop.stocks.first.id
        get :new, params: {cart_id: another_consumer.cart.id, stock_id: stock_id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match('You are not the owner of this cart')
      end
    end

    context "when consumer tries to add a product twice in his cart" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
        consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
      end
      it "returns a success response" do
        stock_id = partner.shop.stocks.first.id
        get :new, params: {cart_id: consumer.cart.id, stock_id: stock_id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(consumer_shop_url(partner.shop))
        expect(flash[:alert]).to match('This product is already in your cart. If you want more,
          please go to your cart and increase the quantity for it')
      end
    end

    context "when signed in user is not an consumer" do
      before do
        sign_in(partner, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response and redirects to root path" do
        stock_id = partner.shop.stocks.first.id
        get :new, params: {cart_id: consumer.cart.id, stock_id: stock_id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match('The page you were looking for requires consumer access rights')
      end
    end

    context "when no user is signed in" do
      before do
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response and redirects to sign in path" do
        stock_id = partner.shop.stocks.first.id
        get :new, params: {cart_id: consumer.cart.id, stock_id: stock_id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end


end
