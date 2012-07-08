class UsersController < ApplicationController
  # layout 'profile', except: [:new ]
  require 'tools/dropbox/dropbox_sdk'

  before_filter :signed_in_user, only: [:show, :edit, :update, :destroy]
  before_filter :correct_user
 
  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    respond_to do |format|
      format.html { render 'static_pages/home'}
      format.json { render json: @user }
    end
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
    Rails.logger.info "> UserController: current_user: #{current_user.username} | #{session[:user_id]}"
    @github_account = Tools::GithubAccount.find_by_user_id(current_user.id)
    @user = User.find_by_username(params[:id])

    db_client = init_db_client
    @db_account = db_client.account_info
    respond_to do |format|
      format.html # show.html.erb
      format.js {}
      format.json { render json: @user }
    end
  end
 
  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
      respond_to do |format|
        if @user.save
          Rails.logger.info " WRONG USER"
          @user.create_profile
          sign_in @user
          format.html { redirect_to "/profiles/#{@user.username}", :flash => { :success => 'Welcome to the One Spark!' }}
          format.json { render json: @user, status: :created, location: @user }
        else
          format.html { render 'static_pages/home', layout: 'static_pages' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
  end
    
  # GET /users/1/edit
  def edit
      @user = User.find_by_username(params[:id])
  end
  
  # PUT /users/1
  # PUT /users/1.json
  def update
      @user = User.find_by_username(params[:id])
      
      respond_to do |format|
        if @user.update_attributes(params[:user])
          sign_in @user #TODO Bug, why do i have to sign in again?
          format.html { redirect_to @user, :flash => { :success => 'Profile updated' }}
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
    end
  end
    
  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find_by_username(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to goodbye_path, :flash => { :success => 'Your account has been deleted.' }}
      format.json { head :no_content }
    end
  end


private

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
  end
  
  def correct_user
    @user = User.find_by_username(params[:id])
    render 'public/404' unless current_user?(@user)
  end

  def init_db_client
    # need to store details
    dbsession = DropboxSession.deserialize(session[:dropbox_session])
    client = DropboxClient.new(dbsession) #raise an exception if session not authorized
        
  end
  
end
