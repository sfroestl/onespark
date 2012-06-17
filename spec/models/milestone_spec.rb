require 'spec_helper'

describe Milestone do
  

  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project, user: user) }
  # let!(:user) { User.first }
  let!(:milestone) { FactoryGirl.create(:milestone, project: project, user: user) }
  subject { milestone }

  it { should respond_to(:title) }
  it { should respond_to(:desc) }
  it { should respond_to(:due_date) }
  it { should respond_to(:user_id) }

  describe "Create Milestone" do

    describe "with no valid title" do 
      before { milestone.title = nil }
      it { should_not be_valid }
    end

    describe "with no due date" do 
      before { milestone.due_date = nil }
      it { should be_valid }
    end

    describe "with due date in past" do 
      before { milestone.due_date = 5.days.ago }
      it { should_not be_valid }
    end
  end

  describe "when project is deleted" do

    it "should destroy project" do
      expect { project.destroy }.to change { Project.count }.by(-1)
    end

    it "and also destroy ticket" do
      expect { milestone.destroy }.to change { Milestone.count }.by(-1)
    end
  end
end
