require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:activity1) { FactoryGirl.create(:activity, user: user, title: "Example Project", description: "Example Description", due_date: 5.days.from_now) }
    let!(:activity2) { FactoryGirl.create(:activity, user: user, title: "Example Project") }

    before do 
      sign_in user
      visit user_path(user) 
    end
    
    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
    
      describe "activities" do
          it { should have_content(activity1.title) }
          it { should have_content(activity2.title) }
          it { should have_content(user.activities.count) }
        end
      
  end
  
  describe "signup" do

      before { visit signup_path }

      let(:submit) { "Create my account" }

      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end
        describe "error messages" do
            before { click_button submit }

            it { should have_selector('title', text: 'Sign up') }
            it { should have_content('error') }
            end
      end

      describe "with valid information" do
        before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "foobar"
          fill_in "Confirmation", with: "foobar"
        end

        it "should create a user" do
          expect { click_button submit }.to change(User, :count).by(1)
        end
        describe "after saving the user" do
          before { click_button submit }
          let(:user) { User.find_by_email('user@example.com') }

          it { should have_selector('title', text: user.name) }
          it { should have_selector('div.alert.alert-success', text: 'Welcome') }
          it { should have_link('Sign out') }
         end
      end
    end
    
    describe "edit" do
        let(:user) { FactoryGirl.create(:user) }
        before do
              sign_in user
              visit edit_user_path(user)
            end

        describe "page" do
          it { should have_selector('h1',    text: "Update your profile") }
          it { should have_selector('title', text: "Edit user") }
          it { should have_link('Delete your account') }
        end

        describe "with invalid information" do
          before { click_button "Save changes" }

          it { should have_content('error') }
        end
        describe "with valid information" do
          let(:new_name)  { "New Name" }
          let(:new_email) { "new@example.com" }
          before do
            fill_in "Name",             with: new_name
            fill_in "Email",            with: new_email
            fill_in "Password",         with: user.password
            fill_in "Confirmation", with: user.password
            click_button "Save changes"
          end

          it { should have_selector('title', text: new_name) }
          it { should have_selector('div.alert.alert-success') }
          it { should have_link('Sign out', href: signout_path) }
          specify { user.reload.name.should  == new_name }
          specify { user.reload.email.should == new_email }
                
        end
      describe "delete account" do
        before { click_link('Delete your account') }
        it { should have_content 'account has been deleted' }
        describe "and try to signup again" do
          before do 
            visit signin_path 
            sign_in user
          end
          it { should have_content('Invalid') }
          
        end
      end
   end
end