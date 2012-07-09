class SessionsController < ApplicationController
layout 'static_pages', only: [:new]
  def create
    user = User.find_by_email(params[:email_or_username])
    user ||= User.find_by_username(params[:email_or_username])

    respond_to do |format|
      if user && user.authenticate(params[:password])
        sign_in user
        format.html { redirect_back_or projects_path }
      else
        format.html { redirect_to :back, :flash => { :error => 'Invalid email, username / password combination' } }
      end
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
