# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

require 'spec_helper'

describe User do
  
  before do
    @user = User.new(name: "Testuser", email:"test@example.org", password: "foobar", password_confirmation: "foobar")
  end
  
  subject { @user }
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:activities) }
  
  it { should be_valid }
  
  describe "when name is not present" do
    before { @user.name = "" }
    it { should_not be_valid }
  end
  
  describe "when email is not present" do
      before { @user.email = " " }
      it { should_not be_valid }
  end
  
  describe "when username too long " do
    before { @user.name = "x"*51 }
    it { should_not be_valid }
  end
  
  describe "when email not valid" do
    it "should be invalid" do
      emails = %w[xyz.me.de 123@asd @mail.de asd@mail www@foo,com]
      emails.each do |invalid_email| 
        @user.email = invalid_email
        @user.should_not be_valid
      end
    end
  end
  
  describe "when email valid" do
    it "should be valid" do
      emails = %w[xyz@me.de 123@asd.com me@mail.de asd@mail.org www@foo.com]
      emails.each do |valid_email| 
        @user.email = valid_email
        @user.should be_valid
      end
    end
  end
  
  describe "when email address is already taken" do
      before do
        user_with_same_email = @user.dup
        user_with_same_email.email = @user.email.upcase
        user_with_same_email.save
      end
      it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end
  
  describe "return value of authenticate method" do
    before { @user.save }
    it { should be_true }
  end
  
  describe "remember token" do
      before { @user.save }
      its(:remember_token) { should_not be_blank }
  end
  
  describe "activities associations" do

    before { @user.save }
    let!(:far_activity) do 
      FactoryGirl.create(:activity, title:"far away due date activity", user: @user, due_date: 6.day.from_now)
    end
    let!(:close_activity) do
      FactoryGirl.create(:activity, title:"close due date activity", user: @user, due_date: 1.days.from_now)
    end

    it "should have the right activities in the right order" do
      @user.activities.should == [close_activity, far_activity]
      @user.activities.should_not == [far_activity, close_activity]
    end
    
    it "should destroy associated activities" do
      activities = @user.activities
      @user.destroy
      activities.each do |activity|
        Activity.find_by_id(activity.id).should be_nil
      end
    end
  end
end
