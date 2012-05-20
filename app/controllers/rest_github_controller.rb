class RestGithubController < ApplicationController

  require 'rest-clients/github_oauth'
  require 'rest_client'
  
  @@client = GithubOauth.new
  
  def index
    Rails.logger.info "Github controller loaded index"
    github_account = GithubAccount.find_by_user_id(current_user.id)
    @@client.initialize_token(github_account.access_token)
    @git_repos = @@client.getReposList
  end
  
  def show
    Rails.logger.info ">> Params: #{params[:repo_owner]}"
    @git_repo = @@client.getRepoDetails(params[:repo_owner], params[:repo_name])
    @git_repo_commits = @@client.getRepoCommitsList(params[:repo_owner], params[:repo_name])
    @git_repo_collaborators = @@client.getRepoCollaboratorsList(params[:repo_owner], params[:repo_name])
  end
  
  
  def unlink_oauth2
    Rails.logger.info "Unlink GitHub account"
    github_account = GithubAccount.find_by_user_id(current_user.id)
    github_account.destroy
    redirect_to current_user
  end
  
  def link_oauth2
    Rails.logger.info "Linking GitHub Account for user"
    redirect_to "#{OAUTH2_CONFIG['github_client_auth_url']}?client_id=#{OAUTH2_CONFIG['github_client_id']}"
  end
  
  def return_oauth2
    Rails.logger.info "first callback landed"
    #callback from GitHub
    
    if params[:error_reason] and not params[:error_reason].empty?
      # Any errors? flash and log them + redirect
      Rails.logger.error "Unable to activate github: #{params[:error_reason]}"
      flash[:error] = "Unable to activate github: #{params[:error_reason]}"
      redirect_to current_user
     
    elsif params[:code] and not params[:code].empty?
      # reqested code exists as query parameter
      code = params[:code]
      Rails.logger.info "No error! Returnded code: " + code
      Rails.logger.info "starting authentication..."
      
      # Authenticates with code
      token = @@client.validate_oauth_token(code, OAUTH2_CONFIG['github_client_token_url'])
      unless token.nil?
        # store account & token
        github_account = GithubAccount.create(:user_id => current_user.id)
        github_account.access_token = token
        current_user.github_account = github_account

        # store app_id
        github_account
        Rails.logger.info "Response confirmed"
        flash[:success] = "Your GitHub account has been authentificated"
        redirect_to current_user
      else
        Rails.logger.info "Response error"
        flash[:error] = "Your GitHub account has not been authentificated"
        redirect_to current_user
      end 
      
    end
  end

  private

  def find_and_store_app_id(github_account)
    accounts = @@client.getAuthorizations
    accounts.each do |account|
      #if account['app']['name'] == ""
    end
  end
end
