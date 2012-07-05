require 'spec_helper'

describe Tasklist do
  

  let!(:creator) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project, user: creator) }
  let!(:tasklist) { FactoryGirl.create(:tasklist, project: project, creator: creator) }
  subject { tasklist }

  it { should respond_to(:title) }
  it { should respond_to(:desc) }
  it { should respond_to(:due_date) }
  it { should respond_to(:tasks) }
  it { should respond_to(:creator_id) }

  describe "Create tasklist" do

    describe "should belong to project" do 
      its(:project) { should == project }
    end

    describe "with no valid title" do 
      before { tasklist.title = nil }
      it { should_not be_valid }
    end

    describe "with no due date" do 
      before { tasklist.due_date = nil }
      it { should be_valid }
    end

    describe "with due date in past" do 
      before { tasklist.due_date = 5.days.ago }
      it { should_not be_valid }
    end
  end

  describe "when project is deleted" do

    it "should destroy project" do
      expect { project.destroy }.to change { Project.count }.by(-1)
    end

    it "and also destroy ticket" do
      expect { tasklist.destroy }.to change { Tasklist.count }.by(-1)
    end
  end
end
