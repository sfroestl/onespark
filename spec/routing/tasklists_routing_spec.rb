require "spec_helper"

describe TasklistsController do
  describe "routing" do

    it "routes to #index" do
      get("/tasklists").should route_to("tasklists#index")
    end

    it "routes to #new" do
      get("/tasklists/new").should route_to("tasklists#new")
    end

    it "routes to #show" do
      get("/tasklists/1").should route_to("tasklists#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tasklists/1/edit").should route_to("tasklists#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tasklists").should route_to("tasklists#create")
    end

    it "routes to #update" do
      put("/tasklists/1").should route_to("tasklists#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tasklists/1").should route_to("tasklists#destroy", :id => "1")
    end

  end
end
