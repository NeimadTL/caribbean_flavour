require 'rails_helper'

RSpec.describe Consumer::CartsController, type: :controller do

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

  let(:valid_attributes) {
    { }
  }

  let(:invalid_attributes) {
    { }
  }

  let(:valid_session) { {} }

  describe "GET #show" do
    context "when consumer is signed in" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a success response" do
        get :show, params: {id: consumer.cart.id}, session: valid_session
        expect(response).to be_successful
      end
    end

    context "when customer tries to access cart of another consumer" do
      before do
        sign_in(consumer, nil)
      end
      it "returns a redirect response" do
        get :show, params: {id: another_consumer.cart.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_url)
        expect(flash[:alert]).to match I18n.t('.require_to_be_cart_owner')
      end
    end

    context "when signed in user is not an consumer" do
      before do
        sign_in(partner, nil)
      end
      it "returns a success response and redirects to root path" do
        get :show, params: {id: consumer.cart.id}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to match I18n.t('.requires_consumer_access_rights')
      end
    end

    context "when no user is signed in" do
      it "returns a redirect response and redirects to sign in path" do
        get :show, params: {id: consumer.cart.id.to_param}, session: valid_session
        expect(response).to be_redirect
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

end
