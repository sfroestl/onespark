require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "user page" do
    let(:user) { FactoryGirl.create(:user) }
    before do 
      sign_in user
      visit user_path(user) 
    end

    it { should have_selector('h1',    text: user.username) }
    it { should have_selector('title', text: user.username) }
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
          fill_in "Username",         with: "username"
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

          it { should have_selector('title', text: user.username) }
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
          it { should have_selector('h1',    text: "Update your account") }
          it { should have_selector('title', text: "Edit Account") }
          it { should have_link('Delete your account') }
        end

        describe "with invalid information" do
          before { click_button "Update User" }

          it { should have_content('error') }
        end
        describe "with valid information" do
          let(:new_username)  { "username" }
          let(:new_email) { "new@example.com" }
          before do
            fill_in "Username",  with: new_username
            fill_in "Email",     with: new_email
            fill_in "Password",  with: user.password
            fill_in "Confirmation", with: user.password
            click_button "Update User"
          end

          it { should have_selector('title', text: new_username) }
          it { should have_selector('div.alert.alert-success') }
          it { should have_link('Sign out', href: signout_path) }
          specify { user.reload.username.should  == new_username }
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
