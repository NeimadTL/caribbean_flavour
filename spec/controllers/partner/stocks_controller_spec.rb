require 'rails_helper'

RSpec.describe Partner::StocksController, type: :controller do

  let(:partner) {
    User.create!(username: "partner", firstname: "partner_firstname", lastname: "partner_lastname",
    city: "city", email: "partner@gmail.com", phone_number: "0394274839", street: "street",
    additional_address_information: "additional address", postcode: "97119",
    country: "country", is_partner: false, role_code: Role::PARTNER_ROLE_CODE,
    password: "12345678", password_confirmation: "12345678")
  }

  let(:another_partner) {
    User.create!(username: "another_partner", firstname: "another_partner_firstname",
    lastname: "another_partner_lastname", city: "city", email: "anotherlpartner@gmail.com",
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

  let(:shop_attributes) {
    { name: 'new shop', product_category_code: 1, delivery_option_ids: [1, 2] }
  }

  let(:another_shop_attributes) {
    { name: 'another shop', product_category_code: 2, delivery_option_ids: [3, 4] }
  }

  let(:product) {
    Product.create!(reference: 'dummy_ref', name: 'dummy_product', product_category_id: ProductCategory::FARMING_CATEGORY_CODE)
  }

  # let(:stock_attributes) {
  #   { product_reference: product.reference, price: 1 }
  # }

  let(:valid_attributes) {
    { product_reference: product.reference, price: 1 }
  }

  let(:invalid_attributes) {
    { price: "" }
  }

  let(:valid_session) { {} }


  describe "GET #new" do
    context "when partner is signed in" do
      before do
        sign_in(partner, nil)
        partner.create_shop(shop_attributes)
      end
      it "returns a success response" do
        get :new, params: {shop_id: partner.shop.id}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when partner hasn't created his shop yet" do
      before do
        sign_in(partner, nil)
      end
      it "returns a redirect response" do
        expect(partner.shop.nil?).to be_truthy
        get :new, params: {shop_id: Random.new.rand(2000..3000)}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(partner_shops_url)
      end
    end

    context "when partner tries to add a product to the shop of another partner" do
      before do
        sign_in(partner, nil)
        partner.create_shop(shop_attributes)
        another_partner.create_shop(another_shop_attributes)
      end
      it "returns a redirect response" do
        get :new, params: {shop_id: another_partner.shop.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_shop_owner')
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
        partner.create_shop(shop_attributes)
      end
      it "returns a redirect response and redirects to root path" do
        get :new, params: {shop_id: partner.shop.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_partner_access_rights')
      end
    end

    context "when no user is signed in" do
      before { partner.create_shop(shop_attributes) }
      it "returns a redirect response and redirects to sign in path" do
        get :new, params: {shop_id: partner.shop.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    context "when partner is signed in" do
      before do
        sign_in(partner, nil)
        partner.create_shop(shop_attributes)
      end
      context "with valid params" do
        it "creates a new Stock" do
          expect {
            post :create, params: {shop_id: partner.shop.id, stock: valid_attributes}, session: valid_session
          }.to change(Stock, :count).by(1)
        end

        it "redirects to the created product" do
          post :create, params: {shop_id: partner.shop.id, stock: valid_attributes}, session: valid_session
          expect(response).to redirect_to partner_shop_url(partner.shop)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {shop_id: partner.shop.id, stock: invalid_attributes}, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    context "when partner hasn't created his shop yet" do
      before do
        sign_in(partner, nil)
      end
      it "returns a redirect response" do
        expect(partner.shop.nil?).to be_truthy
        post :create, params: {shop_id: Random.new.rand(2000..3000), stock: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(partner_shops_url)
      end
    end

    context "when partner tries to create the shop of another partner" do
      before do
        sign_in(partner, nil)
        partner.create_shop(shop_attributes)
        another_partner.create_shop(another_shop_attributes)
      end
      it "returns a redirect response" do
        post :create, params: {shop_id: another_partner.shop.to_param, stock: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_shop_owner')
      end
    end

    context "when partner tries to add twice a product in his shop" do
      before do
        sign_in(partner, nil)
        partner.create_shop(shop_attributes)
        partner.shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response" do
        post :create, params: {shop_id: partner.shop.to_param, stock: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_partner_shop_stock_url(partner.shop))
        expect(flash[:alert]).to match I18n.t('.product_in_shop_already')
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
        partner.create_shop(shop_attributes)
      end
      it "returns a redirect response and redirects to root path" do
        post :create, params: {shop_id: partner.shop.to_param, stock: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_partner_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        partner.create_shop(shop_attributes)
        post :create, params: {shop_id: partner.shop.to_param, stock: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do
    context "when partner is signed in" do
      before do
        sign_in(partner, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a success response" do
        stock = partner.shop.stocks.first
        get :edit, params: {shop_id: partner.shop.id, id: stock.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when partner hasn't created his shop yet" do
      before do
        sign_in(partner, nil)
      end
      it "returns a redirect response" do
        expect(partner.shop.nil?).to be_truthy
        get :edit, params: {shop_id: Random.new.rand(2000..3000), id: Random.new.rand(2000..3000)}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(partner_shops_url)
      end
    end

    context "when partner tries to edit product in another partner's shop by using another partner's shop" do
      before do
        sign_in(partner, nil)
        partner.create_shop(shop_attributes)
        shop = another_partner.create_shop(another_shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response" do
        stock = another_partner.shop.stocks.first
        get :edit, params: {shop_id: another_partner.shop.to_param, id: stock.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_shop_owner')
      end
    end

    context "when partner tries to edit product in shop of another partner's shop by using its shop" do
      before do
        sign_in(partner, nil)
        partner.create_shop(shop_attributes)
        shop = another_partner.create_shop(another_shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response" do
        stock = another_partner.shop.stocks.first
        get :edit, params: {shop_id: partner.shop.to_param, id: stock.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_shop_owner_product')
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response and redirects to root path" do
        stock = partner.shop.stocks.first
        get :edit, params: {shop_id: partner.shop.to_param, id: stock.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_partner_access_rights')
      end
    end

    context "when no user is signed in" do
      before do
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response and redirects to sign in" do
        stock = partner.shop.stocks.first
        get :edit, params: {shop_id: partner.shop.to_param, id: stock.to_param}, session: valid_session
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
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      context "with valid params" do
        it "updates the requested stock" do
          stock = partner.shop.stocks.first
          put :update, params: {shop_id: partner.shop.id, id: stock.to_param, stock: new_attributes}, session: valid_session
          stock.reload
          expect(stock.price).to eql 9
        end

        it "redirects to the stock" do
          stock = partner.shop.stocks.first
          put :update, params: {shop_id: partner.shop.id, id: stock.to_param, stock: valid_attributes}, session: valid_session
          expect(response).to redirect_to partner_shop_url(partner.shop)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          stock = partner.shop.stocks.first
          put :update, params: {shop_id: partner.shop.id, id: stock.to_param, stock: invalid_attributes}, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    context "when partner hasn't created his shop yet" do
      before do
        sign_in(partner, nil)
      end
      it "returns a redirect response" do
        expect(partner.shop.nil?).to be_truthy
        put :update, params: {shop_id: Random.new.rand(2000..3000), id: Random.new.rand(2000..3000), stock: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(partner_shops_url)
      end
    end

    context "when partner tries to update prooduct in another partner's shop by using another partner's shop" do
      before do
        sign_in(partner, nil)
        partner.create_shop(shop_attributes)
        shop = another_partner.create_shop(another_shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response" do
        stock = another_partner.shop.stocks.first
        put :update, params: {shop_id: another_partner.shop.to_param, id: stock.to_param, stock: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_shop_owner')
      end
    end

    context "when partner tries to update prooduct in another partner's shop by using its shop" do
      before do
        sign_in(partner, nil)
        partner.create_shop(shop_attributes)
        shop = another_partner.create_shop(another_shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response" do
        stock = another_partner.shop.stocks.first
        put :update, params: {shop_id: partner.shop.to_param, id: stock.to_param, stock: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_shop_owner_product')
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response and redirects to root path" do
        stock = partner.shop.stocks.first
        put :update, params: {shop_id: partner.shop.to_param, id: stock.to_param, stock: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_partner_access_rights')
      end
    end

    context "when no user is signed in" do
      before do
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response and redirects to sign in" do
        stock = partner.shop.stocks.first
        put :update, params: {shop_id: partner.shop.to_param, id: stock.to_param, stock: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when consumer is signed in" do
      before do
        sign_in(partner, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "destroys the requested product" do
        stock = partner.shop.stocks.first
        expect {
          delete :destroy, params: {shop_id: partner.shop.to_param, id: stock.id}, session: valid_session
        }.to change(Stock, :count).by(-1)
      end

      it "redirects to the consumer's cart" do
        stock = partner.shop.stocks.first
        delete :destroy, params: {shop_id: partner.shop.to_param, id: stock.id}, session: valid_session
        expect(response).to redirect_to(partner_shop_url(partner.shop))
      end
    end

    context "when consumer tries to delete prooduct in another partner's shop by using another partner's shop" do
      before do
        sign_in(partner, nil)
        partner.create_shop(shop_attributes)
        shop = another_partner.create_shop(another_shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response" do
        stock = another_partner.shop.stocks.first
        delete :destroy, params: {shop_id: another_partner.cart.id, id: stock.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_shop_owner')
      end
    end

    context "when consumer tries to delete prooduct in another partner's shop by using its shop" do
      before do
        sign_in(partner, nil)
        shop = partner.create_shop(shop_attributes)
        shop = another_partner.create_shop(another_shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response" do
        stock = another_partner.shop.stocks.first
        delete :destroy, params: {shop_id: partner.shop.to_param, id: stock.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_shop_owner_product')
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response and redirects to root path" do
        stock = partner.shop.stocks.first
        delete :destroy, params: {shop_id: partner.shop.to_param, id: stock.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_partner_access_rights')
      end
    end

    context "when no user is signed in" do
      before do
        shop = partner.create_shop(shop_attributes)
        shop.stocks << Stock.new(valid_attributes)
      end
      it "returns a redirect response and redirects to sign in" do
        stock = partner.shop.stocks.first
        delete :destroy, params: {shop_id: partner.shop.to_param, id: stock.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end


end
