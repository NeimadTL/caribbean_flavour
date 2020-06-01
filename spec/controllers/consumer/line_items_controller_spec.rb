require 'rails_helper'

RSpec.describe Consumer::LineItemsController, type: :controller do

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

  let(:product) {
    Product.create!(reference: 'dummy_ref', name: 'dummy_product', product_category_id: ProductCategory::FARMING_CATEGORY_CODE)
  }

  let(:stock_attributes) {
    { product_reference: product.reference, price: 2.2 }
  }

  let(:valid_attributes) {
    { quantity: 3 }
  }

  let(:invalid_attributes) {
    { quantity: "" }
  }

  let(:valid_session) { {} }

  describe "GET #new" do
    context "when partner is signed in" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
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
        shop = partner.create_shop!(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
      end
      it "returns a success response" do
        stock_id = partner.shop.stocks.first.id
        get :new, params: {cart_id: another_consumer.cart.id, stock_id: stock_id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.require_to_be_cart_owner')
      end
    end

    context "when consumer tries to add a product twice in his cart" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
      end
      it "returns a success response" do
        stock_id = partner.shop.stocks.first.id
        get :new, params: {cart_id: consumer.cart.id, stock_id: stock_id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(consumer_shop_url(partner.shop))
        expect(flash[:alert]).to match I18n.t('.item_in_cart_already')
      end
    end

    context "when consumer tries to buy from a that doen't deliver in his city" do
      before do
        sign_in(consumer, nil)
        shop_attributes[:city_ids].delete("97119")
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
      end
      it "returns a success response" do
        stock_id = partner.shop.stocks.first.id
        get :new, params: {cart_id: consumer.cart.id, stock_id: stock_id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(consumer_shop_url(partner.shop))
        expect(flash[:alert]).to match I18n.t('.no_delivery_msg')
      end
    end

    context "when signed in user is not an consumer" do
      before do
        sign_in(partner, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
      end
      it "returns a redirect response and redirects to root path" do
        stock_id = partner.shop.stocks.first.id
        get :new, params: {cart_id: consumer.cart.id, stock_id: stock_id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_consumer_access_rights')
      end
    end

    context "when no user is signed in" do
      before do
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
      end
      it "returns a redirect response and redirects to sign in path" do
        stock_id = partner.shop.stocks.first.id
        get :new, params: {cart_id: consumer.cart.id, stock_id: stock_id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    context "when consumer is signed in" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
      end
      context "with valid params" do
        it "creates a new Stock" do
          stock_id = partner.shop.stocks.first.id
          valid_attributes['stock_id'] = stock_id
          expect {
            post :create, params: {cart_id: consumer.cart.id, stock_id: stock_id, line_item: valid_attributes}, session: valid_session
          }.to change(LineItem, :count).by(1)
        end

        it "redirects to the created product" do
          stock_id = partner.shop.stocks.first.id
          valid_attributes['stock_id'] = stock_id
          post :create, params: {cart_id: consumer.cart.id, stock_id: stock_id, line_item: valid_attributes}, session: valid_session
          expect(response).to redirect_to consumer_cart_url(consumer.cart)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          stock_id = partner.shop.stocks.first.id
          valid_attributes['stock_id'] = stock_id
          post :create, params: {cart_id: consumer.cart.id, stock_id: stock_id, line_item: invalid_attributes}, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    context "when consumer tries to create an item for another consumer" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
      end
      it "returns a success response" do
        stock_id = partner.shop.stocks.first.id
        valid_attributes['stock_id'] = stock_id
        post :create, params: {cart_id: another_consumer.cart.id, stock_id: stock_id, line_item: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.require_to_be_cart_owner')
      end
    end

    context "when consumer tries to buy from a that doen't deliver in his city" do
      before do
        sign_in(consumer, nil)
        shop_attributes[:city_ids].delete("97119")
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
      end
      it "returns a success response" do
        stock_id = partner.shop.stocks.first.id
        valid_attributes['stock_id'] = stock_id
        post :create, params: {cart_id: consumer.cart.id, stock_id: stock_id, line_item: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(consumer_shop_url(partner.shop))
        expect(flash[:alert]).to match I18n.t('.no_delivery_msg')
      end
    end

    context "when signed in user is not an consumer" do
      before do
        sign_in(partner, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
      end
      it "returns a redirect response and redirects to root path" do
        stock_id = partner.shop.stocks.first.id
        valid_attributes['stock_id'] = stock_id
        post :create, params: {cart_id: consumer.cart.id, stock_id: stock_id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_consumer_access_rights')
      end
    end

    context "when no user is signed in" do
      before do
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
      end
      it "returns a redirect response and redirects to sign in" do
        stock_id = partner.shop.stocks.first.id
        valid_attributes['stock_id'] = stock_id
        post :create, params: {cart_id: consumer.cart.id, stock_id: stock_id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do
    context "when partner is signed in" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
      end
      it "returns a success response" do
        stock_id = partner.shop.stocks.first.id
        item = consumer.cart.line_items.first
        get :edit, params: {cart_id: consumer.cart.id , stock_id: stock_id, id: item.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when partner tries to edit cart of another consumer" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        another_consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
      end
      it "returns a redirect response" do
        stock_id = partner.shop.stocks.first.id
        item = another_consumer.cart.line_items.first
        get :edit, params: {cart_id: another_consumer.cart.id , stock_id: stock_id, id: item.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_cart_owner')
      end
    end

    context "when partner tries to edit cart of another consumer by using its cart and another consumer's item" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        another_consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
      end
      it "returns a redirect response" do
        stock_id = partner.shop.stocks.first.id
        item = another_consumer.cart.line_items.first
        get :edit, params: {cart_id: consumer.cart.id , stock_id: stock_id, id: item.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_cart_owner_item')
      end
    end

    context "when signed in user is not an consumer" do
      before do
        sign_in(partner, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
      end
      it "returns a redirect response and redirects to root path" do
        stock_id = partner.shop.stocks.first.id
        item = consumer.cart.line_items.first
        get :edit, params: {cart_id: another_consumer.cart.id , stock_id: stock_id, id: item.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_consumer_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
        stock_id = partner.shop.stocks.first.id
        item = consumer.cart.line_items.first
        get :edit, params: {cart_id: another_consumer.cart.id , stock_id: stock_id, id: item.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PUT #update" do
    let(:new_attributes) { { quantity: 2 } }
    context "when consumer signed in" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
      end
      context "with valid params" do

        it "updates the requested item" do
          stock_id = partner.shop.stocks.first.id
          item = consumer.cart.line_items.first
          put :update, params: {cart_id: consumer.cart.id , stock_id: stock_id, id: item.id, line_item: new_attributes}, session: valid_session
          item.reload
          expect(item.quantity).to eql 2
        end

        it "redirects to the consumer's cart" do
          stock_id = partner.shop.stocks.first.id
          item = consumer.cart.line_items.first
          put :update, params: {cart_id: consumer.cart.id , stock_id: stock_id, id: item.id, line_item: new_attributes}, session: valid_session
          expect(response).to redirect_to consumer_cart_url(consumer.cart)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          stock_id = partner.shop.stocks.first.id
          item = consumer.cart.line_items.first
          put :update, params: {cart_id: consumer.cart.id , stock_id: stock_id, id: item.id, line_item: invalid_attributes}, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    context "when consumer tries to update item in the cart of another consumer" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        another_consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
      end
      it "returns a redirect response" do
        stock_id = partner.shop.stocks.first.id
        item = another_consumer.cart.line_items.first
        put :update, params: {cart_id: another_consumer.cart.id , stock_id: stock_id, id: item.id, line_item: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_cart_owner')
      end
    end

    context "when consumer tries to update item in the cart of another consumer by using its cart and another consumer's item" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        another_consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
      end
      it "returns a redirect response" do
        stock_id = partner.shop.stocks.first.id
        item = another_consumer.cart.line_items.first
        put :update, params: {cart_id: consumer.cart.id , stock_id: stock_id, id: item.id, line_item: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_cart_owner_item')
      end
    end

    context "when signed in user is not an consumer" do
      before do
        sign_in(partner, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
      end
      it "returns a redirect response and redirects to root path" do
        stock_id = partner.shop.stocks.first.id
        item = consumer.cart.line_items.first
        put :update, params: {cart_id: consumer.cart.id , stock_id: stock_id, id: item.id, line_item: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_consumer_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
        stock_id = partner.shop.stocks.first.id
        item = consumer.cart.line_items.first
        put :update, params: {cart_id: consumer.cart.id , stock_id: stock_id, id: item.id, line_item: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when consumer is signed in" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
      end
      it "destroys the requested item" do
        stock_id = partner.shop.stocks.first.id
        item = consumer.cart.line_items.first
        expect {
          delete :destroy, params: {cart_id: consumer.cart.id , stock_id: stock_id, id: item.id}, session: valid_session
        }.to change(LineItem, :count).by(-1)
      end

      it "redirects to the consumer's cart" do
        stock_id = partner.shop.stocks.first.id
        item = consumer.cart.line_items.first
        delete :destroy, params: {cart_id: consumer.cart.id , stock_id: stock_id, id: item.id}, session: valid_session
        expect(response).to redirect_to(consumer_cart_url(consumer.cart))
      end
    end

    context "when consumer tries to delete item in the cart of another consumer" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        another_consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
      end
      it "returns a redirect response" do
        stock_id = partner.shop.stocks.first.id
        item = another_consumer.cart.line_items.first
        delete :destroy, params: {cart_id: another_consumer.cart.id, stock_id: stock_id, id: item.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_cart_owner')
      end
    end

    context "when consumer tries to delete item in the cart of another consumer by using its cart and another consumer's item" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        another_consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
      end
      it "returns a redirect response" do
        stock_id = partner.shop.stocks.first.id
        item = another_consumer.cart.line_items.first
        delete :destroy, params: {cart_id: consumer.cart.id, stock_id: stock_id, id: item.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_cart_owner_item')
      end
    end

    context "when signed in user is not an consumer" do
      before do
        sign_in(partner, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
      end
      it "returns a redirect response and redirects to root path" do
        stock_id = partner.shop.stocks.first.id
        item = consumer.cart.line_items.first
        delete :destroy, params: {cart_id: consumer.cart.id, stock_id: stock_id, id: item.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_consumer_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(stock_attributes)
        consumer.cart.line_items << LineItem.new(stock_id: shop.stocks.first.id, quantity: 3)
        stock_id = partner.shop.stocks.first.id
        item = consumer.cart.line_items.first
        delete :destroy, params: {cart_id: consumer.cart.id, stock_id: stock_id, id: item.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end


end
