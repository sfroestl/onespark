require 'spec_helper'

describe Profile do

  let(:user) { FactoryGirl.create(:user) }
  let(:profile) { FactoryGirl.create(:profile, user: user) }

  it "should not create profile without user" do
    Profile.new.should_not be_valid
    user.save.should be_true
  end

  it "profile with user is valid" do
    profile.should be_valid
    user.profile.should == profile
    profile.user_id.should == user.id
  end

end
