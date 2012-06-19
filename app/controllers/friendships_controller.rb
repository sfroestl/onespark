class FriendshipsController < ApplicationController
  def create
    friend = User.find(params[:friend_id])

    if Friendship.request(current_user, friend)
      flash[:success] = "Successfully requested friendship with #{friend.username}."
      redirect_to profiles_path
    elsif Friendship.exists?(current_user, friend)
      flash[:notice] = "Friendship with #{friend.username} already requested."
      redirect_to profiles_path
    else
      flash[:error] = "Unable to requested friendship with #{friend.username}."
      redirect_to profiles_path
    end
  end

  def accept
    friend = User.find(params[:friend_id])

    if Friendship.exists?(current_user, friend)
      Friendship.accept(current_user, friend)
      flash[:success] = "Successfully accepted friendship."
      redirect_to profile_path(current_user)
    else
      flash[:error] = "Unable to accept friendship."
      redirect_to profile_path(current_user)
    end
  end

  def remove
    friend = User.find(params[:friend_id])

    if Friendship.exists?(current_user, friend)
      Friendship.breakup(current_user, friend)
      flash[:success] = "Successfully removed friendship."
      redirect_to profile_path(current_user)
    else
      flash[:error] = "Unable to remove friendship."
      redirect_to profile_path(current_user)
    end
  end

  def destroy
    friend = User.find(params[:friend_id])

    if Friendship.exists?(current_user, friend)
      Friendship.breakup(user, friend)
      flash[:success] = "Successfully removed friendship."
      redirect_to profile_path(current_user)
    else
      flash[:error] = "Unable to remove friendship."
      render profile_path(current_user)
    end
  end


end
