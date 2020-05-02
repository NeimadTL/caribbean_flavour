require 'rails_helper'

RSpec.describe Partner::StocksController, type: :controller do

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

  let(:product) {
    Product.create!(reference: 'dummy_ref', name: 'dummy_product', product_category_id: ProductCategory::FARMING_CATEGORY_CODE)
  }

  let(:valid_attributes) {
    { product_reference: product.reference, price: 1, shop_id: shop.id }
  }

  let(:invalid_attributes) {
    { price: 0.99 }
  }

  let(:valid_session) { {} }


  describe "GET #new" do
    context "when partner is signed in" do
      before do
        sign_in(partner, nil)
      end
      it "returns a success response" do
        get :new, params: {shop_id: shop.id}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a redirect response and redirects to root path" do
        get :new, params: {shop_id: shop.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match('The page you were looking for requires partner access rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in path" do
        get :new, params: {shop_id: shop.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    context "when partner is signed in" do
      before do
        sign_in(partner, nil)
      end
      context "with valid params" do
        it "creates a new Stock" do
          expect {
            post :create, params: {shop_id: shop.id, stock: valid_attributes}, session: valid_session
          }.to change(Stock, :count).by(1)
        end

        it "redirects to the created product" do
          post :create, params: {shop_id: shop.id, stock: valid_attributes}, session: valid_session
          expect(response).to redirect_to partner_shop_url(shop)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {shop_id: shop.id, stock: invalid_attributes}, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a redirect response and redirects to root path" do
        post :create, params: {shop_id: shop.id, stock: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match('The page you were looking for requires partner access rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        post :create, params: {shop_id: shop.id, stock: valid_attributes}, session: valid_session
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
        stock = Stock.create! valid_attributes
        get :edit, params: {shop_id: shop.id, id: stock.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a redirect response and redirects to root path" do
        stock = Stock.create! valid_attributes
        get :edit, params: {shop_id: shop.id, id: stock.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match('The page you were looking for requires partner access rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        stock = Stock.create! valid_attributes
        get :edit, params: {shop_id: shop.id, id: stock.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PUT #update" do
    let(:new_attributes) { { price: 9 } }
    context "when partner signed in" do
      before do
        sign_in(partner, nil)
      end
      context "with valid params" do

        it "updates the requested stock" do
          stock = Stock.create! valid_attributes
          put :update, params: {shop_id: shop.id, id: stock.to_param, stock: new_attributes}, session: valid_session
          stock.reload
          expect(stock.price).to eql 9
        end

        it "redirects to the stock" do
          stock = Stock.create! valid_attributes
          put :update, params: {shop_id: shop.id, id: stock.to_param, stock: valid_attributes}, session: valid_session
          expect(response).to redirect_to partner_shop_url(shop)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          stock = Stock.create! valid_attributes
          put :update, params: {shop_id: shop.id, id: stock.to_param, stock: invalid_attributes}, session: valid_session
          expect(response).to be_redirect
        end
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a redirect response and redirects to root path" do
        stock = Stock.create! valid_attributes
        put :update, params: {shop_id: shop.id, id: stock.to_param, stock: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match('The page you were looking for requires partner access rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        stock = Stock.create! valid_attributes
        put :update, params: {shop_id: shop.id, id: stock.to_param, stock: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end


end
