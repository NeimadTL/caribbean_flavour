require "rails_helper"

RSpec.describe Partner::OrdersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/partner/orders").to route_to("partner/orders#index")
    end

    it "routes to #new" do
      expect(get: "/partner/orders/new").to route_to("partner/orders#new")
    end

    it "routes to #show" do
      expect(get: "/partner/orders/1").to route_to("partner/orders#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/partner/orders/1/edit").to route_to("partner/orders#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/partner/orders").to route_to("partner/orders#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/partner/orders/1").to route_to("partner/orders#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/partner/orders/1").to route_to("partner/orders#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/partner/orders/1").to route_to("partner/orders#destroy", id: "1")
    end
  end
end
