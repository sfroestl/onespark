require 'spec_helper'

describe Project do
  
  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project, user: user) }
  
  subject { project }
  
  it { should respond_to(:title) }
  it { should respond_to(:desc) }
  it { should respond_to(:due_date) }
  it { should respond_to(:creator_id) }
  
  describe "Create Project" do
    
    describe "with no valid title" do 
      before { project.title = nil }
      it { should_not be_valid }
    end
    
    describe "with no due date" do 
      before { project.due_date = nil }
      it { should be_valid }
    end
    
    describe "with due date in past" do 
      before { project.due_date = 5.days.ago }
      it { should_not be_valid }
    end
  end 
  
  describe "when project is deleted" do
    
    it "should destroy project" do
      expect { project.destroy }.to change { Project.count }.by(-1)
    end
  end
end
