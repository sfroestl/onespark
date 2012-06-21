require 'spec_helper'

describe ProjectCoworker do

  let(:writer) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:write_permission) { project.project_coworkers.build(user_id: writer.id, permission: 2) }

  subject { write_permission }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to writer via user_id" do
      expect do
        ProjectCoworker.new(project_id: project.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "writer methods" do    
    it { should respond_to(:user) }
    it { should respond_to(:project) }
    its(:user) { should == writer }
    its(:project) { should == project }
    its(:permission) { should == 2}
  end

  describe "when writer id is not present" do
    before { write_permission.user_id = nil }
    it { should_not be_valid }
  end

  describe "when permission is more than 3" do
    before { write_permission.permission = 4 }
    it { should_not be_valid }
  end

  describe "when project id is not present" do
    before { write_permission.project_id = nil }
    it { should_not be_valid }
  end
end