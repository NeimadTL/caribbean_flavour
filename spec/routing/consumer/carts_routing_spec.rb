require "rails_helper"

RSpec.describe Consumer::CartsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/consumer/carts").to route_to("consumer/carts#index")
    end

    it "routes to #new" do
      expect(get: "/consumer/carts/new").to route_to("consumer/carts#new")
    end

    it "routes to #show" do
      expect(get: "/consumer/carts/1").to route_to("consumer/carts#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/consumer/carts/1/edit").to route_to("consumer/carts#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/consumer/carts").to route_to("consumer/carts#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/consumer/carts/1").to route_to("consumer/carts#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/consumer/carts/1").to route_to("consumer/carts#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/consumer/carts/1").to route_to("consumer/carts#destroy", id: "1")
    end
  end
end
