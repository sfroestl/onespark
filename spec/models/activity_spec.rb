require 'spec_helper'

describe Activity do
    
  let(:user) { FactoryGirl.create(:user) }
  
  before do 
    @activity = user.activities.build(title: "Example Activity", description: "This is an example activity", due_date: 1.day.from_now)
  end
  subject { @activity }
  
  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
  
  describe "when user_id is not present" do
    before { @activity.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "when title is not present" do
    before { @activity.title = nil }
    it { should_not be_valid }
  end
  
  describe "when due date is not present" do
    before { @activity.due_date = nil }
    it { should be_valid }
  end
  
  describe "accessible attributes" do
      it "should not allow access to user_id" do
        expect do
          Activity.new(user_id: user.id)
        end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end   
       
      describe "should not allow to add due date in past" do
          before { @activity.due_date = 1.day.ago }
          it { should_not be_valid }
      end
    end
  describe "delete activity" do
    before { @activity.delete }
      it "should be deleted" do
        expect { Activity.find(@activity.id) == nil}
      end
    end
end
