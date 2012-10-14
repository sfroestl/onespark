##
# The SessionsController class
#
# handles the sing_in and sign_out methods
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012


class SessionsController < ApplicationController
layout 'static_pages', only: [:new]

  # sign in
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

  # sign out
  def destroy
    sign_out
    redirect_to root_path
  end
end
