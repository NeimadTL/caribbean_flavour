require "rails_helper"

RSpec.describe Consumer::ShopsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/consumer/shops").to route_to("consumer/shops#index")
    end

    it "routes to #new" do
      expect(get: "/consumer/shops/new").to route_to("consumer/shops#new")
    end

    it "routes to #show" do
      expect(get: "/consumer/shops/1").to route_to("consumer/shops#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/consumer/shops/1/edit").to route_to("consumer/shops#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/consumer/shops").to route_to("consumer/shops#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/consumer/shops/1").to route_to("consumer/shops#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/consumer/shops/1").to route_to("consumer/shops#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/consumer/shops/1").to route_to("consumer/shops#destroy", id: "1")
    end
  end
end
