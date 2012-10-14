##
# The Tools::GithubAccountsController class
#
# this class manages the association user - githaub account
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012


class Tools::GithubAccountsController < ApplicationController
	include SessionsHelper

  require 'tools/github/github_api'

  def index
  end

  # Starts the OAuth2 authorisation process by transmitting the client_id via redirect to the auth-url
  def auth
    # store project
    cookies[:oauth_project_id] = params[:project_id]
    Rails.logger.info">> GitHub AUTH: request: #{request.fullpath} cookie #{cookies[:oauth_project_id]} proj.id #{params[:project_id]}"

    Rails.logger.info ">> GithubTool: authorize App | #{current_user.username} | #{session[:user_id]}"
    @current_user ||= User.find(session[:user_id])
    redirect_to "#{GITHUB_CONFIG['auth_url']}?client_id=#{GITHUB_CONFIG['id']}&scope=user,repo"
  end

  # Handles the callback from github and interchanges of the temporary code with access token
  def callback
    Rails.logger.info ">> GithubTool: callback #{session[:user_id]}"

    if params[:code] and not params[:code].empty?
      Rails.logger.info ">> GithubTool: authcode: #{params[:code]} | #{current_user.username}"

      @github_api = GitHubApi.new
      token = GitHubApi.get_token(params[:code])

      respond_to do |format|
        unless token.nil?
        	Rails.logger.info ">> GithubTool: token: #{token}, current_user: #{@current_user.username}"

        	# store account & token
        	@current_user.create_github_account(access_token: token)
          flash[:success] = 'Successfully linked GitHub account!'
          unless cookies[:oauth_project_id].eql? ""
        	 format.html { redirect_to new_project_github_path(cookies[:oauth_project_id]) }
          else
            format.html { redirect_to projects_path }
          end
        else
        	format.html
        end
      end
  	end
  end

  # Deletes the github account for the current user
  def unlink
    Rails.logger.info ">> GithubTool: Unlink GitHub account"
    current_user.github_account.destroy
    respond_to do |format|
      format.html { redirect_to current_user, :flash => { :success => 'Successfully unlinked GitHub account!' } }
      format.js { }
    end
  end

  private

  # gets the access token
  def fetch_token
  	@github_api.get_token(params[:code])
  end

end
