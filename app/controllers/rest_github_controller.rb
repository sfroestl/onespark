class RestGithubController < ApplicationController
  
  require 'rest-clients/github'
  
  @@client = nil

  def index
    Rails.logger.info "Github controller loaded index"
    if @@client.nil?
      flash.now[:error] = "Please link a github account!"
    else
      @git_repos = @@client.getReposArray
      Rails.logger.info ">> RestGithubController: linked_git_account = " + @linked_git_account
    end
  end
  
  def show
    if @@client.nil?
      flash.now[:error] = "Please link a github account!"
    else
      @git_repo = @@client.getRepoDetailsHash(params[:repo_name])
      Rails.logger.info ">> RestGithubController: linked_git_account = " + @linked_git_account
    end
  end
  
  def link_account
     @@client = Github.new(params[:username], params[:password])
     link_git_account(params[:username]) # user_id
     Rails.logger.info ">> RestGithubController: linked_git_account = " + @linked_git_account
     flash[:success] = "You have linked a github account!"
     redirect_to user_path
  end
end
