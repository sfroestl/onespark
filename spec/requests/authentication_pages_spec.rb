require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end
  
  describe "signin" do
      before { visit signin_path }

      describe "with invalid information" do
        before { click_button "Sign in" }

        it { should have_selector('title', text: 'Sign in') }
        it { should have_selector('div.alert.alert-error', text: 'Invalid') }
        describe "after visiting another page" do
        
        before { click_link "One Spark" }
          it { should_not have_selector('div.alert.alert-error') }
        end
      end
    end
    
    describe "with valid information" do
          let(:user) { FactoryGirl.create(:user) }
          before { sign_in user }

          it { should have_selector('title', text: user.username) }
          it { should have_link('Profile',  href: profile_path(user)) }
          it { should have_link('Settings', href: user_path(user)) }
          it { should have_link('Sign out', href: signout_path) }
          it { should_not have_link('Sign in', href: signin_path) }
    end
    
    describe "authorization" do

       describe "for non-signed-in users" do
        let(:user) { FactoryGirl.create(:user) }

        describe "in the Users controller" do

          describe "visiting the edit page" do
            before { visit edit_user_path(user) }
            it { should have_selector('title', text: 'Sign in') }
          end

          describe "submitting to the update action" do
            before { put user_path(user) }
            specify { response.should redirect_to(signin_path) }
          end
        end
      end
      
      describe "as wrong user" do
          let(:user) { FactoryGirl.create(:user) }
          let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }

          describe "visiting Users#edit page" do
            before do 
              sign_in user
              visit edit_user_path(wrong_user) 
            end
            it { should have_content('The page you were looking for doesn\'t exist.')}
            it { should_not have_selector('title', text: full_title('Update Account')) }
            it { should_not have_selector('h1', text: full_title('Update your')) }
          end

          describe "submitting a PUT request to the Users#update action" do
            before do 
              sign_in user
              put user_path(wrong_user)
            end
            #TODO write working test. it shoul not allow to put at user_path
            # specify { response.should redirect_to(root_path) }
            # it { should have_content('The page you were looking for doesn\'t exist.')}
          end
        end
    end
    
    describe "for non-signed-in users" do
        let(:user) { FactoryGirl.create(:user) }

        describe "when attempting to visit a protected page" do
          before do
            visit user_path(user)
            fill_in "email_or_username",    with: user.email
            fill_in "password", with: user.password
            click_button "Sign in"
          end

          describe "after signing in" do

            it "should render the desired protected page" do
              page.should have_content(user.email)
            end
          end
        end
      end
end