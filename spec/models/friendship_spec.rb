require 'spec_helper'

describe Friendship do
  
  # let(:user1) { FactoryGirl.create(:user) }
  # let(:friend1) { FactoryGirl.create(:user) }
  # let!(:friendship) { user.friendships.create(friend_id: friend1.id) }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:friend) { FactoryGirl.create(:user) }
  let(:friendship) { Friendship.request(user, friend) } 


  it { should respond_to(:user) }
  it { should respond_to(:friend) }
  it { should respond_to(:status) }

  # describe "friendship should be correct" do
 	# before { @fs = Friendship.find(1) }
 	# it "should have all atributes" do 
 	#   @fs.should_not be_nil 
 	#   @fs.user_id.should == 1
 	# end
  # end

  describe "other friendship should be correct" do
 	before do 
 	  Friendship.request(user, friend)
  	  @friendship_pending = Friendship.find_by_user_id_and_friend_id(user, friend)
 	  @friendship_request = Friendship.find_by_user_id_and_friend_id(friend, user)
 	end
 	
 	it "pending friendship should have all attributes" do 
 	  @friendship_pending.should_not be_nil 
 	  @friendship_pending.user_id.should == user.id
 	  @friendship_pending.friend_id.should == friend.id
 	  @friendship_pending.status.should == 'pending' 	  
    end

    it "user should have friend in pending firends list" do
      user.pending_friends.should include friend
    end

    it "request friendship should have all atributes" do 
 	  @friendship_request.should_not be_nil 
 	  @friendship_request.user_id.should == friend.id
 	  @friendship_request.friend_id.should == user.id
 	  @friendship_request.status.should == 'requested'
 	end

    it "friend should have user as requested friends list" do
      friend.requested_friends.should include user
    end
  end

  describe "accepting a friendship" do
  	before do
  	  Friendship.request(user, friend)
  	  Friendship.accept(user, friend)
  	  @friendship_pending = Friendship.find_by_user_id_and_friend_id(user, friend)
 	  @friendship_request = Friendship.find_by_user_id_and_friend_id(friend, user)
 	end

  	it "should set both friendships accepted" do
  		@friendship_pending.status.should == 'accepted'
  		@friendship_request.status.should == 'accepted'
    end

    it "both user und friend should be in each others friendships" do
      user.friendships.should include @friendship_pending
  	  friend.friendships.should include @friendship_request
  	  user.friends.should include friend
  	  friend.friends.should include user
    end
  end

  describe "declining a friendship" do
  	before do
      Friendship.request(user, friend)
  	  Friendship.breakup(user, friend)
  	  @friendship_pending = Friendship.find_by_user_id_and_friend_id(user, friend)
 	  @friendship_request = Friendship.find_by_user_id_and_friend_id(friend, user)
 	end
  	it "should destroy both friendships" do
  		@friendship_pending.should be_nil
  		@friendship_request.should be_nil
    end
  end
end
