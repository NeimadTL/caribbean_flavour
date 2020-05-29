require 'rails_helper'

RSpec.describe Consumer::OrdersController, type: :controller do

  let(:consumer) {
    User.create!(username: "consu", firstname: "consu_firstname", lastname: "consu_lastname",
    email: "consu@gmail.com", phone_number: "0394274839", street: "street",
    additional_address_information: "additional address", city_postcode: "97119",
    country_code: "971", is_partner: false, role_code: Role::CONSUMER_ROLE_CODE,
    password: "12345678", password_confirmation: "12345678")
  }

  let(:another_consumer) {
    User.create!(username: "another_consu", firstname: "another_consu_firstname",
    lastname: "another_consu_lastname", email: "another_consu@gmail.com",
    phone_number: "0394274839", street: "street", additional_address_information: "additional address",
    city_postcode: "97119", country_code: "971", is_partner: false, role_code: Role::CONSUMER_ROLE_CODE,
    password: "12345678", password_confirmation: "12345678")
  }

  let(:partner) {
    User.create!(username: "partner", firstname: "partner_firstname", lastname: "partner_lastname",
    email: "partner@gmail.com", phone_number: "0394274839", street: "street",
    additional_address_information: "additional address", city_postcode: "97119",
    country_code: "971", is_partner: false, role_code: Role::PARTNER_ROLE_CODE,
    password: "12345678", password_confirmation: "12345678")
  }

  let(:shop_attributes) {
    { name: 'new shop', product_category_code: 1, delivery_option_ids: [1, 2],
      country_code: "971", city_postcode: "97119", city_ids: ["97119", "97123"],
      phone_number: "0590772266", street: "some street" }
  }

  let(:valid_attributes) {
    { delivery_option_code: 1, user_id: consumer.id }
  }

  let(:invalid_attributes) {
    { delivery_option_code: "" }
  }

  let(:valid_session) { {} }

  describe "GET #new" do
    context "when partner is signed in" do
      before do
        sign_in(consumer, nil)
        partner.create_shop(shop_attributes)
      end
      it "returns a success response" do
        get :new, params: {cart_id: consumer.cart.id, shop_id: partner.shop.id}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when consumer tries to create an order for another one consumer" do
      before do
        sign_in(consumer, nil)
        partner.create_shop(shop_attributes)
      end
      it "returns a success response" do
        get :new, params: {cart_id: another_consumer.cart.id, shop_id: partner.shop.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.require_to_be_cart_owner')
      end
    end

    context "when signed in user is not an consumer" do
      before do
        sign_in(partner, nil)
        partner.create_shop(shop_attributes)
      end
      it "returns a redirect response and redirects to root path" do
        get :new, params: {cart_id: consumer.cart.id, shop_id: partner.shop.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_consumer_access_rights')
      end
    end

    context "when no user is signed in" do
      before { partner.create_shop(shop_attributes) }
      it "returns a redirect response and redirects to sign in path" do
        get :new, params: {cart_id: consumer.cart.id, shop_id: partner.shop.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    context "when consumer is signed in" do
      before do
        sign_in(consumer, nil)
        partner.create_shop(shop_attributes)
      end
      context "with valid params" do
        it "creates a new Order" do
          expect {
            post :create, params: {cart_id: consumer.cart.id, shop_id: partner.shop.id, order: valid_attributes}, session: valid_session
          }.to change(Order, :count).by(1)
        end

        it "redirects to the created product" do
          post :create, params: {cart_id: consumer.cart.id, shop_id: partner.shop.id, order: valid_attributes}, session: valid_session
          expect(response).to redirect_to consumer_order_url(Order.last)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {cart_id: consumer.cart.id, shop_id: partner.shop.id, order: invalid_attributes}, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    context "when consumer tries to create an order for another one consumer" do
      before do
        sign_in(consumer, nil)
        partner.create_shop(shop_attributes)
      end
      it "returns a success response" do
        get :new, params: {cart_id: another_consumer.cart.id, shop_id: partner.shop.id, order: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.require_to_be_cart_owner')
      end
    end

    context "when signed in user is not an consumer" do
      before do
        sign_in(partner, nil)
        partner.create_shop(shop_attributes)
      end
      it "returns a redirect response and redirects to root path" do
        post :create, params: {cart_id: consumer.cart.id, shop_id: partner.shop.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_consumer_access_rights')
      end
    end

    context "when no user is signed in" do
      before { partner.create_shop(shop_attributes) }
      it "returns a redirect response and redirects to sign in" do
        post :create, params: {cart_id: consumer.cart.id, shop_id: partner.shop.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #index" do
    context "when partner is signed in" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a success response" do
        get :index, params: {}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when signed in user is not an consumer" do
      before do
        sign_in(partner, nil)
      end
      it "returns a redirect response and redirects to root path" do
        get :index, params: {}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_consumer_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in path" do
        get :index, params: {}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #show" do
    context "when consumer is signed in" do
      before { sign_in(consumer, nil) }
      it "returns a success response" do
        order = Order.create! valid_attributes
        get :show, params: {id: order.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when consumer tries to access an order of another consumer" do
      before { sign_in(consumer, nil) }
      it "returns a redirect response" do
        order = Order.create! valid_attributes.merge(user_id: partner.id)
        get :show, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_order_owner')
      end
    end

    context "when signed in user is not an consumer" do
      before do
        sign_in(partner, nil)
      end
      it "returns a success response and redirects to root path" do
        order = Order.create! valid_attributes
        get :show, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_consumer_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in path" do
        order = Order.create! valid_attributes
        get :show, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when a is signed in" do
      before { sign_in(consumer, nil) }
      it "destroys the requested roder" do
        order = Order.create! valid_attributes
        expect {
          delete :destroy, params: {id: order.to_param}, session: valid_session
        }.to change(Order, :count).by(-1)
      end

      it "redirects to the products list" do
        order = Order.create! valid_attributes
        delete :destroy, params: {id: order.to_param}, session: valid_session
        expect(response).to redirect_to(consumer_orders_url)
      end
    end

    context "when consumer tries to cancel an order of another consumer" do
      before { sign_in(consumer, nil) }
      it "returns a redirect response" do
        order = Order.create! valid_attributes.merge(user_id: partner.id)
        delete :destroy, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_order_owner')
      end
    end

    context "when consumer tries to cancel an order which is not in ordered status anymore" do
      before { sign_in(consumer, nil) }
      it "returns a redirect response" do
        order = Order.create! valid_attributes.merge(user_id: consumer.id, status_id: 1)
        delete :destroy, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to consumer_order_url(order)
        expect(flash[:alert]).to match I18n.t('.require_ordered_status')
      end
    end

    context "when signed in user is not an consumer" do
      before do
        sign_in(partner, nil)
      end
      it "returns a redirect response and redirects to root path" do
        order = Order.create! valid_attributes
        delete :destroy, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_consumer_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        order = Order.create! valid_attributes
        delete :destroy, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end



end
