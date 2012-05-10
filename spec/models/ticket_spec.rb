require 'spec_helper'

describe Ticket do
  before do 
    @project = Factory.create(:project)
    @ticket2 = Ticket.new(title:"Testticket", desc:"This is a sample Ticket", due_date: 1.week.from_now)
    @ticket = @project.tickets.build(title:"Testticket 2", desc:"This is a sample Ticket 2", due_date: 1.week.from_now)
  end
  
  describe "without project id" do
    subject { @ticket2 }
    it { should_not be_valid }
  end
  
  subject { @ticket }
  
  it { should respond_to(:title) }
  it { should respond_to(:desc) }
  it { should respond_to(:due_date) }
  it { should respond_to(:project_id) }
  
  describe "with no valid title" do 
    before { @ticket.title = nil }
    it { should_not be_valid }
  end
  
  describe "with no valid project_id" do 
    before { @ticket.project_id = nil }
    it { should_not be_valid }
  end
  
  describe "with no due date" do 
    before { @ticket.due_date = nil }
    it { should be_valid }
  end
  
  describe "with due date in past" do 
    before { @ticket.due_date = 5.days.ago }
    it { should_not be_valid }
  end
end
