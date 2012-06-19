class ProfilesController < ApplicationController
 before_filter :setup_friends, only: [:show]
 # before_filter signed_id?
  # def create

  #   @profile = Profile.new(params[:profile])
  #   if @profile.save
  #     redirect_to @profile, :notice => "Successfully created profile."
  #   else
  #     render :action => 'new'
  #   end
  # end

  def show
    @user = User.find_by_username(params[:username])
    @profile = @user.profile
    @profile ||= @user.create_profile 
  end

  def index
    @profiles = Profile.find(:all, order: "surname")
  end

  def edit
    @user = User.find_by_username(params[:username])
    @profile = @user.profile
    @profile ||= @user.create_profile 
  end

  def update
    @user = User.find_by_username(params[:username])
    @profile = @user.profile
    @profile ||= @user.create_profile 
    if @profile.update_attributes(params[:profile])
      redirect_to "/profiles/#{@user.username}", :flash => { :success => "Successfully updated your profile." }
    else
      render :action => 'edit'
    end
  end


private
  def setup_friends
    @user = User.find_by_username(params[:username])
    @friends = @user.friends
    @pending_friends = @user.pending_friends
    @requested_friends = @user.requested_friends
  end
end
