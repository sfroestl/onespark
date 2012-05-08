require 'spec_helper'

describe "ActivityPages" do
  subject { page }
  
  let (:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  
  describe "activity creation"
    before { visit user_path(user) }
    
    describe "with invalid information" do
      it "should not create an activity" do
        expect { click_button "Create Activity" }.should_not change(Activity, :count)
    end
    describe "error messages" do
      before { click_button "Create Activity" }
      it { should have_content('error') } 
    end
  end
  
  describe "with valid information" do

    before { fill_in 'activity_title', with: "Lorem ipsum" }
      it "should create activity" do
        expect { click_button "Create Activity" }.should change(Activity, :count).by(1)
      end
  end
end
