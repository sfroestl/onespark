require 'spec_helper'
require 'rest-clients/github'
require 'rest_client'

describe Github do
  
  before { @client = Github.new('sfroestl', 'fr1bb3#GH') }
  
  describe "should have valid client" do
    specify { @client.should_not be_nil }
  
      describe "client returns user details" do
        before do 
          @user_details = @client.getUserDetails('sfroestl') 
          @user_repos = @client.getUserReposArray
        end

        it "should return correct user details" do
          #puts @user_details
          @user_details['login'].should == "sfroestl"
        end
        
        it "should return correct user repos" do
          #puts @user_repos
         # @user_repos['name'].should == "onespark" => unauthorized
        end
      end
  end
end