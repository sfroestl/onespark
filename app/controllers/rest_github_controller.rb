class RestGithubController < ApplicationController
  
  GITHUB_ACCOUNT = 'github'
  require 'oauth2'
  require 'rest-clients/github'
  
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
    redirect_to "https://github.com/login/oauth/authorize?client_id=03f39de03ec45a7c3523"     
  end
  
  def link_oauth2    
    @client = OAuth2::Client.new(OAUTH2_CONFIG['github_client_id'], OAUTH2_CONFIG['github_client_secret'], {:token_url => '/oauth/access_token',:site => 'https://github.com/login'})
    @client.auth_code.authorize_url(:redirect_uri => 'http://localhost:3000/git/oauth2/callback')
    code = params[:code]
    #puts "Returnded token: " + code
    @token = @client.auth_code.get_token(params[:code], :redirect_uri => user_path)
    puts @token
    render user_path
  end
  

  def return_oauth2
    code = params[:code]
    puts "Returnded token: " + code
    @token = @client.auth_code.get_token(:code => code, :redirect_uri => user_path)
    puts @token
    render 'callback'
    
    #redirect_to "https://github.com/login/oauth/access_toke?code=#{code}&client_id=de64951d04de304adf5b&secret=a341a8114d3b8e49b509f14ea7e9974e936998dd&redirect_to=localhost:3000/back_again"
    #params = {:code => 'e3783c0f47a376b56c47', :client_id => '03f39de03ec45a7c3523', :client_secret => 'fb114499bd1ddfe9f1db5e7bebaa016cb6c93ad7', :redirect_uri => 'http://localhost:3000/back_again'}
    #resp = RestClient.post 'https://github.com/login/oauth/access_toke', params
    
    #puts resp
  end
end
