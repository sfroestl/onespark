require File.dirname(__FILE__) + '/../spec_helper'

describe MilestonesController do
  fixtures :all
  render_views

  it "create action should render new template when model is invalid" do
    Milestones.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Milestones.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(milestones_url(assigns[:milestones]))
  end

  it "update action should render edit template when model is invalid" do
    Milestones.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Milestones.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Milestones.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Milestones.first
    response.should redirect_to(milestones_url(assigns[:milestones]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Milestones.first
    response.should render_template(:edit)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Milestones.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "destroy action should destroy model and redirect to index action" do
    milestones = Milestones.first
    delete :destroy, :id => milestones
    response.should redirect_to(milestones_url)
    Milestones.exists?(milestones.id).should be_false
  end
end
