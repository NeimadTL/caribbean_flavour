require 'rails_helper'

RSpec.describe Partner::ShopsController, type: :controller do

  let(:partner) {
    User.create!(username: "partner", firstname: "partner_firstname", lastname: "partner_lastname",
    email: "partner@gmail.com", phone_number: "0394274839", street: "street",
    additional_address_information: "additional address", city_postcode: "97119",
    country_code: "971", is_partner: false, role_code: Role::PARTNER_ROLE_CODE,
    password: "12345678", password_confirmation: "12345678")
  }

  let(:another_partner) {
    User.create!(username: "another_partner", firstname: "another_partner_firstname",
    lastname: "another_partner_lastname", email: "anotherlpartner@gmail.com",
    phone_number: "0394274839", street: "street",additional_address_information: "additional address",
    city_postcode: "97119", country_code: "971", is_partner: false, role_code: Role::PARTNER_ROLE_CODE,
    password: "87654321", password_confirmation: "87654321")
  }

  let(:consumer) {
    User.create!(username: "consu", firstname: "consu_firstname", lastname: "consu_lastname",
    email: "consu@gmail.com", phone_number: "0394274839", street: "street",
    additional_address_information: "additional address", city_postcode: "97119",
    country_code: "971", is_partner: false, role_code: Role::CONSUMER_ROLE_CODE,
    password: "12345678", password_confirmation: "12345678")
  }

  let(:valid_attributes) {
    { name: 'new shop', product_category_code: 1, delivery_option_ids: [1, 2],
      country_code: "971", city_postcode: "97119", city_ids: ["97119", "97123"],
      phone_number: "0590772266", street: "some street" }
  }

  let(:another_shop_attributes) {
    { name: 'another_shop', product_category_code: 2, delivery_option_ids: [3, 4],
      country_code: "971", city_postcode: "97119", city_ids: ["97119", "97123"],
      phone_number: "0590772266", street: "some street" }
  }

  let(:invalid_attributes) {
    { name: "" }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    context "when partner is signed in" do
      before do
        sign_in(partner, nil)
      end
      it "returns a success response" do
        get :index, params: {}, session: valid_session
        expect(response).to be_successful
      end
    end

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

  describe "GET #new" do
    context "when partner is signed in" do
      before do
        sign_in(partner, nil)
      end
      it "returns a success response" do
        get :new, params: {}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when partner has a shop and tries to create another one" do
      before do
        sign_in(partner, nil)
        partner.create_shop(valid_attributes)
      end
      it "returns a success response" do
        get :new, params: {}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.allow_one_shop_only')
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a redirect response and redirects to root path" do
        get :new, params: {}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_partner_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in path" do
        get :new, params: {}, session: valid_session
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
        it "creates a new Shop" do
          expect {
            post :create, params: {shop: valid_attributes}, session: valid_session
          }.to change(Shop, :count).by(1)
        end

        it "redirects to the created product" do
          post :create, params: {shop: valid_attributes}, session: valid_session
          expect(response).to redirect_to partner_shop_url(Shop.last)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {shop: invalid_attributes}, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    context "when partner has a shop and tries to create another one" do
      before do
        sign_in(partner, nil)
        partner.create_shop(valid_attributes)
      end
      it "returns a success response" do
        post :create, params: {shop: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.allow_one_shop_only')
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a redirect response and redirects to root path" do
        post :create, params: {shop: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_partner_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        post :create, params: {shop: valid_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #show" do
    context "when partner is signed in" do
      before do
        sign_in(partner, nil)
        partner.create_shop(valid_attributes)
      end
      it "returns a success response" do
        get :show, params: {id: partner.shop.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when partner hasn't created his shop yet" do
      before do
        sign_in(partner, nil)
      end
      it "returns a redirect response" do
        expect(partner.shop.nil?).to be_truthy
        get :show, params: {id: Random.new.rand(2000..3000)}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(partner_shops_url)
      end
    end

    context "when partner tries to access the shop of another partner" do
      before do
        sign_in(partner, nil)
        partner.create_shop(valid_attributes)
        another_partner.create_shop(another_shop_attributes)
      end
      it "returns a redirect response" do
        get :show, params: {id: another_partner.shop.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_shop_owner')
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
        partner.create_shop(valid_attributes)
      end
      it "returns a success response and redirects to root path" do
        get :show, params: {id: partner.shop.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_partner_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in path" do
        partner.create_shop(valid_attributes)
        get :show, params: {id: partner.shop.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do
    context "when partner is signed in" do
      before do
        sign_in(partner, nil)
        partner.create_shop(valid_attributes)
      end
      it "returns a success response" do
        get :edit, params: {id: partner.shop.to_param}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when partner hasn't created his shop yet" do
      before do
        sign_in(partner, nil)
      end
      it "returns a redirect response" do
        expect(partner.shop.nil?).to be_truthy
        get :edit, params: {id: Random.new.rand(2000..3000)}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(partner_shops_url)
      end
    end

    context "when partner tries to access the shop of another partner" do
      before do
        sign_in(partner, nil)
        partner.create_shop(valid_attributes)
        another_partner.create_shop(another_shop_attributes)
      end
      it "returns a redirect response" do
        get :show, params: {id: another_partner.shop.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_shop_owner')
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
        partner.create_shop(valid_attributes)
      end
      it "returns a redirect response and redirects to root path" do
        get :edit, params: {id: partner.shop.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_partner_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        partner.create_shop(valid_attributes)
        get :edit, params: {id: partner.shop.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PUT #update" do
    let(:new_attributes) {
      { name: 'the best shop', product_category_code: 2, delivery_option_ids: [3, 4],
        country_code: "971", city_postcode: "97119", city_ids: ["97119", "97123"],
        phone_number: "0590772266", street: "some street" }
    }
    context "when partner signed in" do
      before do
        sign_in(partner, nil)
        partner.create_shop(valid_attributes)
      end
      context "with valid params" do

        it "updates the requested shop" do
          put :update, params: {id: partner.shop.to_param, shop: new_attributes}, session: valid_session
          partner.shop.reload
          expect(partner.shop.name).to eql "the best shop"
          expect(partner.shop.product_category_code).to eql 2
          expect(partner.shop.delivery_option_ids).to eql [3, 4]
        end

        it "redirects to the shop" do
          put :update, params: {id: partner.shop.to_param, shop: valid_attributes}, session: valid_session
          expect(response).to redirect_to partner_shop_url(partner.shop)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do

          put :update, params: {id: partner.shop.to_param, shop: invalid_attributes}, session: valid_session
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
        put :update, params: {id: Random.new.rand(2000..3000), shop: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(partner_shops_url)
      end
    end

    context "when partner tries to access the shop of another partner" do
      before do
        sign_in(partner, nil)
        partner.create_shop(valid_attributes)
        another_partner.create_shop(another_shop_attributes)
      end
      it "returns a redirect response" do
        put :update, params: {id: another_partner.shop.to_param, shop: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_shop_owner')
      end
    end

    context "when signed in user is not an partner" do
      before do
        sign_in(consumer, nil)
        partner.create_shop(valid_attributes)
      end
      it "returns a redirect response and redirects to root path" do
        put :update, params: {id: partner.shop.to_param, shop: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_partner_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in" do
        partner.create_shop(valid_attributes)
        put :update, params: {id: partner.shop.to_param, shop: new_attributes}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end



end
