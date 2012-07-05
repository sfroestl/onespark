require 'spec_helper'

describe Task do
  let!(:creator) { FactoryGirl.create(:user) }
  let!(:worker) { FactoryGirl.create(:user) }
  let!(:project) { FactoryGirl.create(:project, user: creator) }
  let!(:milestone) { FactoryGirl.create(:milestone, project: project, user: creator) }

  let(:task) { project.tasks.create(title: "new task", creator: creator)}
  
  subject { task }

  it { should respond_to(:title) }
  it { should respond_to(:desc) }
  it { should respond_to(:due_date) }
  it { should respond_to(:worker) }
  it { should respond_to(:creator) }
  it { should respond_to(:milestone) }
  it { should respond_to(:tasklist) }
  it { should respond_to(:project) }

	describe "should have creator but bo worker" do
		before { task.save }
		its(:creator) { should == creator }
		its(:worker) { should be_nil }
	end

  describe "without title is invalid" do
  	it "shahd" do
  		task2 = project.tasks.build(title: "another task")
  		task2.should_not be_valid
  	end
  end

  describe "should have worker" do
  	before do 
  		task.worker = worker
  		task.save
  	end
    its(:worker_id) { should == worker.id }
    its(:worker) { should == worker }
  end

  describe "should have project" do
    its(:project) { should == project }
    its(:project_id) { should == project.id }
  end

  describe "belongs to milestone" do
  	before { task.milestone = milestone }
    its(:milestone) { should == milestone }
    its(:milestone_id) { should == milestone.id }
  end
  
end
