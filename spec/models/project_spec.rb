require 'spec_helper'

describe Project do
  before do 
    @project = Project.new(title:"Testproject", desc:"This is a sample Project", due_date: 1.week.from_now)
  end
  
  subject { @project }
  
  it { should respond_to(:title) }
  it { should respond_to(:desc) }
  it { should respond_to(:due_date) }
  
  describe "with no valid title" do 
    before { @project.title = nil }
    it { should_not be_valid }
  end
  
  describe "with no due date" do 
    before { @project.due_date = nil }
    it { should be_valid }
  end
  
  describe "with due date in past" do 
    before { @project.due_date = 5.days.ago }
    it { should_not be_valid }
  end
  
end
