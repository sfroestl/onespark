class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:show, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update, :destroy]
 
  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
      
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end
  
  # GET /users/1
  # GET /users/1.json
  def show
    @github_account = LinkedAccount.find_by_user_id_and_name(current_user, "github")
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
 
  # POST /users
  # POST /users.json
  def create
      @user = User.new(params[:user])
      
      respond_to do |format|
        if @user.save
          sign_in @user
          format.html { redirect_to @user, :flash => { :success => 'Welcome to the One Spark!' }}
          format.json { render json: @user, status: :created, location: @user }
        else
          format.html { render action: "new" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
  end
    
  # GET /users/1/edit
  def edit
      @user = User.find(params[:id])
  end
  
  # PUT /users/1
  # PUT /users/1.json
  def update
      @user = User.find(params[:id])
      
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
    @user = User.find(params[:id])
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
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
end
