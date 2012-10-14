##
# The FriendshipsController class
#
# this class handels the user - friendship - user association
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012


class FriendshipsController < ApplicationController

  # request a friendship
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

  # accept a friendship
  def accept
    friend = User.find(params[:friend_id])

    respond_to do |format|
      if Friendship.exists?(current_user, friend)
        Friendship.accept(current_user, friend)
        format.html { redirect_to profile_path(current_user), :flash => { :success => "Successfully accepted friendship." }}

      else
        format.html { redirect_to profile_path(current_user), :flash => { :error => "Unable to accepted friendship." }}

      end
    end
  end

  # remove a friendship
  def remove
    friend = User.find(params[:friend_id])

    respond_to do |format|
      if Friendship.exists?(current_user, friend)
        Friendship.breakup(current_user, friend)
        format.html { redirect_to profile_path(current_user), :flash => { :success => "Successfully removed friendship." }}

      else
        format.html { redirect_to profile_path(current_user), :flash => { :error => "Unable to remove friendship." }}

      end
    end
  end
end
