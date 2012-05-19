class RestGithubController < ApplicationController
  
  GITHUB_ACCOUNT = 'github'
  require 'rest-clients/github'
  require 'rest-clients/github_oauth'
  require 'rest_client'
  
  @@client = GithubOauth.new
  
  def index
    Rails.logger.info "Github controller loaded index"
    
    @@client.initialize_token(session[:access_token])
    @git_repos = @@client.getReposList
  end
  
  def show
    Rails.logger.info ">> Params: #{params[:repo_owner]}"
    @@client.initialize_token(session[:access_token])
    @git_repo = @@client.getRepoDetails(params[:repo_owner], params[:repo_name])
    @git_repo_commits = @@client.getRepoCommitsList(params[:repo_owner], params[:repo_name])
    @git_repo_collaborators = @@client.getRepoCollaboratorsList(params[:repo_owner], params[:repo_name])
  end
  
  
  def unlink_oauth
    @github_account = LinkedAccount.find_by_id(current_user.id)
    if @github_account.destroy
      flash[:success] = "You have unlinked a github account!"
      redirect_to user_path
    else
      flash[:error] = "Can't unlinked a github account!"
      redirect_to user_path
    end
  end
  
  def link_oauth
    Rails.logger.info "Linking GitHub Account for user"
    redirect_to "#{OAUTH2_CONFIG['github_client_auth_url']}?client_id=#{OAUTH2_CONFIG['github_client_id']}"
  end
  
  def return_oauth2
    Rails.logger.info "first callback landed"
    #callback from GitHub
    
    if params[:error_reason] and not params[:error_reason].empty?
      # Any errors? falsh and log them + redirect
      Rails.logger.error "Unable to activate github: #{params[:error_reason]}"
      flash[:error] = "Unable to activate github: #{params[:error_reason]}"
      redirect_to current_user
     
    elsif params[:code] and not params[:code].empty?
      # reqested code exists as query parameter
      code = params[:code]
      Rails.logger.info "No error! Returnded code: " + code
      Rails.logger.info "starting authentication..."
      
      # Authenticates with code
      @token = @@client.validate_oauth_token(code, OAUTH2_CONFIG['github_client_token_url'])
      session[:access_token] = @token
      Rails.logger.info "Response confirmed"
      flash[:success] = "Your GitHub account has been authentificated"
      redirect_to current_user
    end
  end
end
