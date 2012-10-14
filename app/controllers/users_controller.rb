##
# The UsersController class
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012

class UsersController < ApplicationController
  # include DropBox Client
  require 'tools/dropbox/dropbox_sdk'

  before_filter :signed_in_user, only: [:show, :edit, :update, :destroy]

  # helper method for edit user
  before_filter :correct_user

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    respond_to do |format|
      format.html { render 'new', layout: 'static_pages'}
      format.json { render json: @user }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    Rails.logger.info "> UserController: current_user: #{current_user.username} | #{session[:user_id]} | DBox session #{session[:dropbox_session]}"
    @github_account = Tools::GithubAccount.find_by_user_id(current_user.id)
    @user = User.find_by_username(params[:id])

    @db_client = init_db_client
    # @db_account = db_client.account_info
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
          format.html { redirect_to projects_path, :flash => { :success => 'Welcome to the One Spark!' }}
          format.json { render json: @user, status: :created, location: @user }
        else
          format.html { render 'new', layout: 'static_pages' }
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
          format.js { render 'shared/_replace_form.js' }
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
  # is the user signed in?
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
  end

  # checks whether the actual user is the displayed user or not
  def correct_user
    @user = User.find_by_username(params[:id])
    render 'public/404' unless current_user?(@user)
  end

  # this method initializes the +dropbox client+
  def init_db_client
    begin
      dbsession = DropboxSession.deserialize(session[:dropbox_session])
      client = DropboxClient.new(dbsession, ACCESS_TYPE) #raise an exception if session not authorized
    rescue Exception => e
      Rails.logger.error ">> DropBox Controller init_client: " + e.message
      session[:dropbox_session] = nil
      Rails.logger.error ">> DropBox Controller reset_session!"
      return
    end
    return client
  end

end
