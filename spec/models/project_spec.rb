require 'spec_helper'

describe Project do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project, user: user) }

  subject { project }

  it { should respond_to(:title) }
  it { should respond_to(:desc) }
  it { should respond_to(:due_date) }
  it { should respond_to(:user_id) }
  it { should respond_to(:tasklists) }
  it { should respond_to(:project_coworkers) }
  it { should respond_to(:coworkers) }
  it { should respond_to(:admin?) }
  it { should respond_to(:admin!) }
  it { should respond_to(:writer?) }
  it { should respond_to(:writer!) }
  it { should respond_to(:reader?) }
  it { should respond_to(:reader!) }

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

    describe "with no owner" do
      before { project.user_id = nil }
      it { should_not be_valid }
    end

    describe "with owner" do
      its(:user_id) { should == user.id }
      it { should be_owner(user) }
      its(:owner_id) { should == user.id }
    end
  end

  describe "when project is deleted" do

    it "should destroy project" do
      expect { project.destroy }.to change { Project.count }.by(-1)
    end
  end

  describe "user is admin" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      project.admin!(other_user)
    end

    it { should be_admin(other_user) }
    it { should_not be_reader(other_user) }
    it { should_not be_writer(other_user) }
    its(:admins) { should include(other_user) }
    its(:coworkers) { should include(other_user) }
  end

  describe "user is not admin" do
    let(:other_user2) { FactoryGirl.create(:user) }
    before do
      project.reader!(other_user2)
    end

    it { should be_reader(other_user2) }
    its(:admins) { should_not include(other_user2) }
    its(:coworkers) { should include(other_user2) }
  end


end
