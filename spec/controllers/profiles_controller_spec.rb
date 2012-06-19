require File.dirname(__FILE__) + '/../spec_helper'

describe ProfilesController do
  fixtures :all
  render_views

  # it "new action should render new template" do
  #   get :new
  #   response.should render_template(:new)
  # end

  # it "create action should render new template when model is invalid" do
  #   Profile.any_instance.stubs(:valid?).returns(false)
  #   post :create
  #   response.should render_template(:new)
  # end

  # it "create action should redirect when model is valid" do
  #   Profile.any_instance.stubs(:valid?).returns(true)
  #   post :create
  #   response.should redirect_to(profile_url(assigns[:profile]))
  # end

  # it "show action should render show template" do
  #   get :show, :id => Profile.first
  #   response.should render_template(:show)
  # end

  # it "index action should render index template" do
  #   get :index
  #   response.should render_template(:index)
  # end

  # it "edit action should render edit template" do
  #   get :edit, :id => Profile.first
  #   response.should render_template(:edit)
  # end

  # it "update action should render edit template when model is invalid" do
  #   Profile.any_instance.stubs(:valid?).returns(false)
  #   put :update, :id => Profile.first
  #   response.should render_template(:edit)
  # end

  # it "update action should redirect when model is valid" do
  #   Profile.any_instance.stubs(:valid?).returns(true)
  #   put :update, :id => Profile.first
  #   response.should redirect_to(profile_url(assigns[:profile]))
  # end

  # it "destroy action should destroy model and redirect to index action" do
  #   profile = Profile.first
  #   delete :destroy, :id => profile
  #   response.should redirect_to(profiles_url)
  #   Profile.exists?(profile.id).should be_false
  # end
end
