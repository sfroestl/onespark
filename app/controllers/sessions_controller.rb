class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email_or_username])
    user ||= User.find_by_username(params[:email_or_username])
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or profile_path(user)
    else
      flash.now[:error] = 'Invalid email, username or password'
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
