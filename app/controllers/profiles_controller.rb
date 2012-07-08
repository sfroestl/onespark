class ProfilesController < ApplicationController

  before_filter :user_exists?, only: [:show]
  before_filter :find_user_and_profile, except: [:index]
  before_filter :setup_friends, only: [:show]
  before_filter :correct_user, except: [:show, :index]
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
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @profile }
    end
  end

  def index
    @profiles = Profile.find(:all, order: "surname")
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to profile_path(@user.username), :flash => { :success => "Successfully updated your profile." } }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def setup_friends
      @user = User.find_by_username(params[:username])
      unless @user.nil?
        @friends = @user.friends
        @pending_friends = @user.pending_friends 
        @requested_friends = @user.requested_friends
      end
    end

    def user_exists?    
      render 'public/404' unless User.find_by_username(params[:username])
    end

    def find_user_and_profile
      @user = User.find_by_username(params[:username])
      @profile = @user.profile
      @profile ||= @user.create_profile 
    end

    def correct_user
      @user = User.find_by_username(params[:username])
      render 'public/404' unless current_user?(@user)
    end
    
end
