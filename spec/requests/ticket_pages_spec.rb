require 'spec_helper'

describe "Ticket Pages" do
  
  subject { page }
  
  let(:project) { FactoryGirl.create(:project) }
  let(:user) { FactoryGirl.create(:user) }
  let(:ticket) { FactoryGirl.create(:ticket, project: project) }
    #project.tickets.build(title: "Example Ticket", desc: "example ticket here", due_date: 3.days.from_now) 

  describe "visit tickets page" do
    before do
      ticket.save
      visit project_ticket_path(project, ticket) 
    end
    
    describe "without signing in" do
      it { should have_content 'sign in'}
      it { should_not have_content ticket.title}
    end
    
    describe "with user signed in" do
      before { sign_in(user) }      
      it { should have_selector('h4', text: ticket.title) }
      it { should have_content ticket.title }
      it { should have_link 'Edit ticket' }
      it { should have_link 'Delete ticket' }
    
      describe "edit ticket with invalid input" do
        before do 
          click_link ticket.title
          fill_in 'Title', with: ''
        end
      
        it "should not update ticket" do
          expect { click_button 'Create ticket' }.not_to change(Ticket, :count)
          should have_content('error')
        end
      
      end
      describe "edit ticket with valid input" do
        before do 
          click_link ticket.title
          fill_in 'Title', with: 'New ticket title'
          click_button 'Create ticket'
        end

        it "should update ticket" do
          should have_content('updated')
        end
      end
      describe "click delete ticket" do
        before { visit project_ticket_path(project, ticket) }
         it "should delete ticket" do
           expect { click_link 'Delete ticket' }.to change(Ticket, :count)
         end
      end
    end
  end
end
