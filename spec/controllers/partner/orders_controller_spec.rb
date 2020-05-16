require 'rails_helper'

RSpec.describe Partner::OrdersController, type: :controller do

  let(:partner) {
    User.create!(username: "partner", firstname: "partner_firstname", lastname: "partner_lastname",
    city: "city", email: "partner@gmail.com", phone_number: "0394274839", street: "street",
    additional_address_information: "additional address", postcode: "97119",
    country: "country", is_partner: false, role_code: Role::PARTNER_ROLE_CODE,
    password: "12345678", password_confirmation: "12345678")
  }

  let(:another_partner) {
    User.create!(username: "another_partner", firstname: "another_partner_firstname",
    lastname: "another_partner_lastname", city: "city", email: "anotherpartner@gmail.com",
    phone_number: "0394274839", street: "street",additional_address_information: "additional address",
    postcode: "97119", country: "country", is_partner: false, role_code: Role::PARTNER_ROLE_CODE,
    password: "87654321", password_confirmation: "87654321")
  }

  let(:consumer) {
    User.create!(username: "consu", firstname: "consu_firstname", lastname: "consu_lastname",
    city: "city", email: "consu@gmail.com", phone_number: "0394274839", street: "street",
    additional_address_information: "additional address", postcode: "97119",
    country: "country", is_partner: false, role_code: Role::CONSUMER_ROLE_CODE,
    password: "12345678", password_confirmation: "12345678")
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
        partner.create_shop(name: 'test', product_category_code: 1, delivery_option_ids: [1, 2])
      end
      it "returns a success response" do
        get :index, params: {}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when partner hasn't created his shop yet" do
      before do
        sign_in(partner, nil)
      end
      it "returns a redirect response" do
        expect(partner.shop.nil?).to be_truthy
        get :index, params: {}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(partner_shops_url)
      end
    end

    # context "when partner tries to access orders of another partner" do
    #   before do
    #     sign_in(partner, nil)
    #     partner.create_shop(name: 'test', product_category_code: 1, delivery_option_ids: [1, 2])
    #     another_partner.create_shop(name: 'another shop', product_category_code: 2, delivery_option_ids: [3, 4])
    #   end
    #   it "returns a redirect response" do
    #     get :index, params: {}, session: valid_session
    #     expect(response).to be_redirect
    #     expect(response).to redirect_to(root_url)
    #     expect(flash[:alert]).to match('You are not the owner of this shop')
    #   end
    # end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a redirect response and redirects to root path" do
        get :index, params: {}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_partner_access_rights')

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
    context "when partner is signed in" do
      before do
        sign_in(partner, nil)
        partner.create_shop(name: 'test', product_category_code: 1, delivery_option_ids: [1, 2])
      end
      it "returns a success response" do
        order = Order.create! valid_attributes
        order.order_line_items.create(name: 'poyo', unit_price: 1, quantity: 2, shop_id: partner.shop.id)
        get :show, params: {id: order.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when partner hasn't created his shop yet" do
      before do
        sign_in(partner, nil)
      end
      it "returns a redirect response" do
        order = Order.create! valid_attributes
        expect(partner.shop.nil?).to be_truthy
        get :show, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(partner_shops_url)
      end
    end

    context "when partner tries to access an order of another partner" do
      before do
        sign_in(partner, nil)
        partner.create_shop(name: 'test', product_category_code: 1, delivery_option_ids: [1, 2])
        another_partner.create_shop(name: 'another shop', product_category_code: 2, delivery_option_ids: [3, 4])
      end
      it "returns a redirect response" do
        order = Order.create! valid_attributes
        order.order_line_items.create(name: 'poyo', unit_price: 1, quantity: 2, shop_id: another_partner.shop.id)
        get :show, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_shop_order')
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
        partner.create_shop(name: 'test', product_category_code: 1, delivery_option_ids: [1, 2])
      end
      it "returns a success response and redirects to root path" do
        order = Order.create! valid_attributes
        order.order_line_items.create(name: 'poyo', unit_price: 1, quantity: 2, shop_id: partner.shop.id)
        get :show, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_partner_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in path" do
        partner.create_shop(name: 'test', product_category_code: 1, delivery_option_ids: [1, 2])
        order = Order.create! valid_attributes
        order.order_line_items.create(name: 'poyo', unit_price: 1, quantity: 2, shop_id: partner.shop.id)
        get :show, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do
    context "when partner is signed in" do
      before do
        sign_in(partner, nil)
        partner.create_shop(name: 'test', product_category_code: 1, delivery_option_ids: [1, 2])
      end
      it "returns a success response" do
        order = Order.create! valid_attributes
        order.order_line_items.create(name: 'poyo', unit_price: 1, quantity: 2, shop_id: partner.shop.id)
        get :edit, params: {id: order.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when partner hasn't created his shop yet" do
      before do
        sign_in(partner, nil)
      end
      it "returns a redirect response" do
        order = Order.create! valid_attributes
        expect(partner.shop.nil?).to be_truthy
        get :edit, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(partner_shops_url)
      end
    end

    context "when partner tries to edit an order of another partner" do
      before do
        sign_in(partner, nil)
        partner.create_shop(name: 'test', product_category_code: 1, delivery_option_ids: [1, 2])
        another_partner.create_shop(name: 'another shop', product_category_code: 2, delivery_option_ids: [3, 4])
      end
      it "returns a redirect response" do
        order = Order.create! valid_attributes
        order.order_line_items.create(name: 'poyo', unit_price: 1, quantity: 2, shop_id: another_partner.shop.id)
        get :edit, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_shop_order')
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
        partner.create_shop(name: 'test', product_category_code: 1, delivery_option_ids: [1, 2])
      end
      it "returns a redirect response and redirects to root path" do
        order = Order.create! valid_attributes
        order.order_line_items.create(name: 'poyo', unit_price: 1, quantity: 2, shop_id: partner.shop.id)
        get :edit, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_partner_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        partner.create_shop(name: 'test', product_category_code: 1, delivery_option_ids: [1, 2])
        order = Order.create! valid_attributes
        order.order_line_items.create(name: 'poyo', unit_price: 1, quantity: 2, shop_id: partner.shop.id)
        get :edit, params: {id: order.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PUT #update" do
    let(:new_attributes) { { status: 'shipped' } }
    let(:order_line_item) {
      OrderLineItem.create(name: 'product', unit_price: 1.5, quantity: 2, shop_id: partner.shop.id)
    }
    context "when partner signed in" do
      before do
        sign_in(partner, nil)
        partner.create_shop(name: 'test', product_category_code: 1, delivery_option_ids: [1, 2])
      end
      context "with valid params" do

        it "updates the requested stock" do
          order = Order.create! valid_attributes
          order.order_line_items << order_line_item
          put :update, params: {id: order.to_param, order: new_attributes}, session: valid_session
          order.reload
          expect(order.status).to eql 'shipped'
        end

        it "redirects to the stock" do
          order = Order.create! valid_attributes
          order.order_line_items << order_line_item
          put :update, params: {id: order.to_param, order: valid_attributes}, session: valid_session
          expect(response).to redirect_to partner_orders_url(order)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          order = Order.create! valid_attributes
          order.order_line_items << order_line_item
          put :update, params: {id: order.to_param, order: invalid_attributes}, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    context "when partner hasn't created his shop yet" do
      before do
        sign_in(partner, nil)
        another_partner.create_shop(name: 'another shop', product_category_code: 2, delivery_option_ids: [3, 4])
      end
      it "returns a redirect response" do
        order = Order.create! valid_attributes
        another_order_line_item = OrderLineItem.create(name: 'another product', unit_price: 5.99, quantity: 3, shop_id: another_partner.shop.id)
        order.order_line_items << another_order_line_item
        expect(partner.shop.nil?).to be_truthy
        put :update, params: {id: order.to_param, order: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(partner_shops_url)
      end
    end

    context "when partner tries to update an order of another partner" do
      before do
        sign_in(partner, nil)
        partner.create_shop(name: 'test', product_category_code: 1, delivery_option_ids: [1, 2])
        another_partner.create_shop(name: 'another shop', product_category_code: 2, delivery_option_ids: [3, 4])
      end
      it "returns a redirect response" do
        order = Order.create! valid_attributes
        another_order_line_item = OrderLineItem.create(name: 'another product', unit_price: 5.99, quantity: 3, shop_id: another_partner.shop.id)
        order.order_line_items << another_order_line_item
        put :update, params: {id: order.to_param, order: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_shop_order')
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a redirect response and redirects to root path" do
        order = Order.create! valid_attributes
        put :update, params: {id: order.to_param, order: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_partner_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        order = Order.create! valid_attributes
        put :update, params: {id: order.to_param, order: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

end
