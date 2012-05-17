class RestGithubController < ApplicationController
  
  GITHUB_ACCOUNT = 'github'
  require 'rest-clients/github'
  require 'rest-clients/github_oauth'
  require 'rest_client'
  
  def index
    Rails.logger.info "Github controller loaded index"
    @github_account = LinkedAccount.find_by_user_id(current_user.id)
    if !@github_account
      flash.now[:error] = "Please link a github account!"
    else
      @@client = Github.new(@github_account.username, @github_account.password)
      @git_repos = @@client.getUserReposArray
      Rails.logger.info ">> RestGithubController: linked_git_account = " + @github_account.username
    end
  end
  
  def show
    @github_account = LinkedAccount.find_by_user_id(current_user.id)
    if !@github_account
      flash.now[:error] = "Please link a github account!"
    else
      @@client = Github.new(@github_account.username, @github_account.password)
      @git_repo = @@client.getRepoDetailsHash(params[:repo_name])
      @git_repo_commits = @@client.getRepoCommits(params[:repo_name])
      Rails.logger.info ">> RestGithubController: linked_git_account = " + @github_account.username
    end
  end
  
  def link_account
    @github_account = LinkedAccount.new(GITHUB_ACCOUNT, params[:username], params[:password], current_user)
    @@client = Github.new(@github_account.username, @github_account.password)
    @user_details = @@client.getUserDetails(params[:username])
    if @github_account.save && @user_details
      Rails.logger.info ">> RestGithubController: linked_git_account = " + @github_account.username
      flash[:success] = "You have linked a github account with username: " + @github_account.username + "!"
      redirect_to user_path
    else
      flash.now[:error] = "Error while linking a github account with username: " + @github_account.username + "!"
      render 'new'
    end
  end
  
  def unlink_account
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
    puts "Linking GitHub Account for user
    redirect_to "https://github.com/login/oauth/authorize?client_id=#{OAUTH2_CONFIG['github_client_id']}"
  end
  
  def return_oauth2
    puts "first callback landed"
    #callback from GitHub | instatiate client
    github_client = GithubOauth.new
    
    if params[:error_reason] && !params[:error_reason].empty?
      # Any errors? falsh and log them + redirect
      puts "Unable to activate github: #{params[:error_reason]}"
      flash[:error] = "Unable to activate github: #{params[:error_reason]}"
      redirect_to current_user
     
    elsif params[:code] && !params[:code].empty?
      # reqested code exists as query parameter
      code = params[:code]
      puts "No error! Returnded code: " + code
      puts "starting authentication..."
      # Authenticates with code
      @token = github_client.validate_oauth_token(code, 'https://github.com/login/oauth/access_token' )
      puts "Response confirmed"
      flash[:success] = "Your GitHub account has been authentificated"
      redirect_to current_user
    end
  end
end
