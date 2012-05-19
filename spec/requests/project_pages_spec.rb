require 'spec_helper'

describe "Project Pages" do

  subject { page }
  let(:project) { FactoryGirl.create(:project) }
  let(:user) { FactoryGirl.create(:user) }
  
  describe "visit as unsigned user" do
     before { visit project_path(project) }
     it { should have_selector('div.alert.alert-notice', text: 'Please sign in') }
  end
  
  describe "as signed user" do
    before do 
      sign_in(user) 
      visit projects_path
    end
    
    describe "visit projects page" do
      it { should have_selector('title', text: 'All projects') }
      it { should have_content('Create new project') }
    end
    
    describe "create new project" do
      before { click_link 'Create new project' }
      it { should have_selector('h1', text: 'Create a new project') }      
      
      describe "fill in invalid information" do
        it "should not create a project" do
          expect { click_button 'Create project' }.not_to change(Project, :count)
        end
        describe "error messages" do
          before { click_button 'Create project' }
            it { should have_content('error') }
          end
        end
      
      describe "with valid information" do
        before "filled in" do
           fill_in "Title",    with: "Example Project 2"
           fill_in "Desc",     with: "Example Project 2 foobar test test"
           fill_in "Due date", with: "12.1.2020"
        end
        it "should create a project" do
          expect { click_button 'Create project' }.to change(Project, :count).by(1)
          should have_content('Project created')
        end
      end
    end
    
    describe "edit a Project" do
      before do 
        project.save 
        visit project_path(project)
      end
      it "should show project" do
        should have_selector('h1', text: project.title)
        should have_selector('a', text: 'Edit')
        should have_selector('a', text: 'Delete')
      end
    end

    describe "visit a project " do
      before { visit project_path(project) }
      it { should have_selector('title', text: project.title) }
      it { should have_content('Create new ticket') }
      
      describe "create new ticket with valid information" do
        before do
          click_link 'new ticket'
          fill_in "Title",    with: "Example Ticket"
          fill_in "Desc",     with: "Example ticket foobar test test"
          fill_in "Due date", with: "12.1.2020"
          click_button 'Create ticket'
        end
        it { should have_content('Ticket was successfully created.') }
        it { should have_content('Example Ticket') }
      end
      describe "create new ticket with invalid information" do
        before do
          click_link 'new ticket'
          click_button 'Create ticket'
        end
        it { should have_content('error') }
      end
    end
  end
end
