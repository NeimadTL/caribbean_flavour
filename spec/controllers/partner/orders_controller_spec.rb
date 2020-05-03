require 'rails_helper'

RSpec.describe Partner::OrdersController, type: :controller do

  let(:partner) {
    User.create!(username: "partner", firstname: "partner_firstname", lastname: "partner_lastname",
    city: "city", email: "partner@gmail.com", phone_number: "0394274839", street: "street",
    additional_address_information: "additional address", postcode: "97119",
    country: "country", is_partner: false, role_code: Role::PARTNER_ROLE_CODE,
    password: "12345678", password_confirmation: "12345678")
  }

  let(:consumer) {
    User.create!(username: "consu", firstname: "consu_firstname", lastname: "consu_lastname",
    city: "city", email: "consu@gmail.com", phone_number: "0394274839", street: "street",
    additional_address_information: "additional address", postcode: "97119",
    country: "country", is_partner: false, role_code: Role::CONSUMER_ROLE_CODE,
    password: "12345678", password_confirmation: "12345678")
  }

  let(:shop) {
    Shop.create!(name: 'new shop', product_category_code: 1, delivery_option_ids: [1, 2], user_id: partner.id)
  }

  let(:valid_attributes) {
    { delivery_option_code: 1, user_id: consumer.id }
  }

  let(:invalid_attributes) {
    { status: 'deliver' }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    context "when partner is signed in" do
      before do
        sign_in(partner, nil)
      end
      it "returns a success response" do
        get :index, params: {shop_id: shop.id}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a redirect response and redirects to root path" do
        get :index, params: {shop_id: shop.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match('The page you were looking for requires partner access rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in path" do
        get :index, params: {shop_id: shop.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #show" do
    context "when partner is signed in" do
      before do
        sign_in(partner, nil)
      end
      it "returns a success response" do
        order = Order.create! valid_attributes
        get :show, params: {shop_id: shop.id, id: order.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a success response and redirects to root path" do
        order = Order.create! valid_attributes
        get :show, params: {shop_id: shop.id, id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match('The page you were looking for requires partner access rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in path" do
        order = Order.create! valid_attributes
        get :show, params: {shop_id: shop.id, id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do
    context "when partner is signed in" do
      before do
        sign_in(partner, nil)
      end
      it "returns a success response" do
        order = Order.create! valid_attributes
        get :edit, params: {shop_id: shop.id, id: order.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a redirect response and redirects to root path" do
        order = Order.create! valid_attributes
        get :edit, params: {shop_id: shop.id, id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match('The page you were looking for requires partner access rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        order = Order.create! valid_attributes
        get :edit, params: {shop_id: shop.id, id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PUT #update" do
    let(:new_attributes) { { status: 'shipped' } }
    let(:order_line_item) {
      OrderLineItem.create(name: 'product', unit_price: 1.5, quantity: 2, shop_id: shop.id)
    }
    context "when partner signed in" do
      before do
        sign_in(partner, nil)
      end
      context "with valid params" do

        it "updates the requested stock" do
          order = Order.create! valid_attributes
          order.order_line_items << order_line_item
          put :update, params: {shop_id: shop.id, id: order.to_param, order: new_attributes}, session: valid_session
          order.reload
          expect(order.status).to eql 'shipped'
        end

        it "redirects to the stock" do
          order = Order.create! valid_attributes
          order.order_line_items << order_line_item
          put :update, params: {shop_id: shop.id, id: order.to_param, order: valid_attributes}, session: valid_session
          expect(response).to redirect_to partner_shop_orders_url(shop, order)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          order = Order.create! valid_attributes
          put :update, params: {shop_id: shop.id, id: order.to_param, order: invalid_attributes}, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a redirect response and redirects to root path" do
        order = Order.create! valid_attributes
        put :update, params: {shop_id: shop.id, id: order.to_param, order: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match('The page you were looking for requires partner access rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        order = Order.create! valid_attributes
        put :update, params: {shop_id: shop.id, id: order.to_param, order: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

end
