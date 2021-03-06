##
# The Tools::GithubRepositoriesController class
#
# this class manages the association project - githaub repository
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012


class Tools::GithubRepositoriesController < ApplicationController
  require 'tools/github/github_api'
  layout 'project', except: [:index]

  before_filter :find_project, except: [:index, :create_repo]

  # GET project/:id/tools/github_repositories
  # GET project/:id/tools/github_repositories.json
  def index

    unless current_user.github_account
      flash[:error] = "No GitHub account linked!"
      return redirect_to @project
    end
    Rails.logger.info ">> GithubRepoController: index"
    github_client = GitHubApi.new
    github_client.init_with_token(current_user.github_account.access_token)


    if github_client
      @user_github_repos = github_client.repos.list
      # @repo_data = @github_api.repos.get(@github_repository.owner, @github_repository.name)

      respond_to do |format|
        format.js
        format.html
        format.json { render json: @user_github_repos }
      end
    end
  end

  # GET project/:id/tools/github_repositories/1
  # GET project/:id/tools/github_repositories/1.json
  def show
    Rails.logger.info ">> GithubRepoController: show"

    unless current_user.github_account
      flash[:error] = "No GitHub account linked!"
      return redirect_to new_github_account_path(@project)
    end
    @github_repository = @project.github_repository

    respond_to do |format|
      if @github_repository
        github_client = GitHubApi.new
        github_client.init_with_token(current_user.github_account.access_token)
        @repo_data = github_client.repos.get(@github_repository.owner, @github_repository.name)
        @repo_events = github_client.events.list(user: @github_repository.owner, repo: @github_repository.name  )
        format.html # show.html.erb
      else
        github_client = GitHubApi.new
        github_client.init_with_token(current_user.github_account.access_token)
        @user_repositories = github_client.repos.list
        format.html { render 'new', :flash => { :error => 'No linked GitHub account!'} }
      end

    end
  end

  def link_account
  end

  # GET project/:id/tools/github_repositories/new
  # GET project/:id/tools/github_repositories/new.json
  def new
    Rails.logger.info ">> GitthubRepoController: new"
    github_client = GitHubApi.new
    github_client.init_with_token(current_user.github_account.access_token)

    @user_repositories = github_client.repos.list
    Rails.logger.info ">> GitthubRepoController: user repos nil? #{@user_repositories.nil?}"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tools_github_repository }
    end
  end

  # POST project/:id/tools/github_repositories
  # POST project/:id/tools/github_repositories.json
  def create
    Rails.logger.info ">> GitthubRepoController: create"

    github_client = GitHubApi.new
    github_client.init_with_token(current_user.github_account.access_token)
    @github_repository = github_client.repos.get( params[:owner], params[:repository])

    Rails.logger.info ">> Chosen Repo: #{@github_repository.url}"

    respond_to do |format|
      if @project.create_github_repository(name: params[:repository], owner: params[:owner], url: @github_repository.url, user_id: current_user.id )
        format.html { redirect_to project_github_path(@project), flash: { success: 'Github repository was successfully linked.' }}
        format.json { render json: @project.github_repository, status: :created, location: @tools_github_repository }
      else
        format.html { render action: "new" }
        format.json { render json: @project.github_repository.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE project/:id/tools/github_repositories/1
  # DELETE project/:id/tools/github_repositories/1.json
  def destroy
    @project.github_repository.destroy
    respond_to do |format|
      format.html { redirect_to project_github_path(@project), flash: { success: 'Github repository was successfully unlinked.' } }
      format.json { head :no_content }
    end
  end

  def issues
    Rails.logger.info ">> GithubRepoController: issues"
    github_client = GitHubApi.new
    github_client.init_with_token(current_user.github_account.access_token)

    @github_repository = @project.github_repository

    respond_to do |format|
      if @github_repository
        @repo_issues = github_client.issues.list(user: @github_repository.owner, repo: @github_repository.name)
        format.html # issues.html.erb
      else
        @user_repositories = github_client.repos.list
        format.html { render 'new', :flash => { :error => 'No GitHub repository linked.'} }
      end
    end
  end

  def commits
    Rails.logger.info ">> GithubRepoController: commits"
    github_client = GitHubApi.new
    github_client.init_with_token(current_user.github_account.access_token)

    @github_repository = @project.github_repository

    respond_to do |format|
      if @github_repository
        @repo_commits = github_client.commits.list(user: @github_repository.owner, repo: @github_repository.name)
        format.html # commits.html.erb
      else
        @user_repositories = github_client.repos.list
        format.html { render 'new', :flash => { :error => 'No GitHub repository linked.'} }
      end
    end
  end

  def create_issue_comment
    Rails.logger.info ">> GithubRepoController: Create issue comment"
    Rails.logger.info ">> GithubRepoController: issue ID: #{params[:id]}"
    Rails.logger.info ">> GithubRepoController: BODY: #{params[:body]}"
    github_client = GitHubApi.new
    github_client.init_with_token(current_user.github_account.access_token)

    @project.github_repository

    begin
      github_client.issues.create_issue_comment(@project.github_repository.owner, @project.github_repository.name, params[:id], { body: params[:body] } )
    rescue Exception => e
      return flash['error'] = "GitHub Error: " + e.message
    end
    redirect_to :back , flash: { success: 'Github comment was successfully created.' }
  end

  def issue_comments
    Rails.logger.info ">> GithubRepoController: issue comments"
    Rails.logger.info ">> GithubRepoController: issue ID: #{params[:id]}"

    github_client = GitHubApi.new
    github_client.init_with_token(current_user.github_account.access_token)

    @github_repository = @project.github_repository
    Rails.logger.info ">> GithubRepoController: Repository: #{@project.github_repository.name}"

    respond_to do |format|
      if @github_repository
        # get issue
        @issue = github_client.issues.get( @project.github_repository.owner, @project.github_repository.name, params[:id] )
        # get comments
        @issue_comments = github_client.issues.get_issue_comments( @project.github_repository.owner, @project.github_repository.name, params[:id] )

        format.html # commits.html.erb
        format.js { }
      else
        @user_repositories = github_client.repos.list
        format.html { render 'new', :flash => { :error => 'No GitHub repository linked.'} }
      end
    end
  end

  def create_repo
    Rails.logger.info ">> GithubRepoController: create repo"
    github_client = GitHubApi.new
    github_client.init_with_token(current_user.github_account.access_token)
    @github_account = current_user.github_account
    unless @github_account.nil?
      begin
        github_client.repos.create( { name: params[:name], description: params[:description] } )
      rescue Exception => e
        return flash['error'] = "GitHub Error: " + e.message
      end
      redirect_to user_github_repos_path(current_user) , flash: { success: 'Github repository was successfully created.' }
    end
  end

  def create_issue
     Rails.logger.info ">> GithubRepoController: create issue"
    github_client = GitHubApi.new
    github_client.init_with_token(current_user.github_account.access_token)
    @github_repository = @project.github_repository

    unless params[:assignee].empty?
      input = { title: params[:title], body: params[:body], assignee: params[:assignee]}
    else
      input = { title: params[:title], body: params[:body] }
    end
    unless @github_repository.nil?
      begin
        github_client.issues.create(@github_repository.owner, @github_repository.name, input )
      rescue Exception => e
        flash['error'] = "GitHub Error: " + e.message
        return redirect_to :back
      end
      redirect_to :back , flash: { success: 'Github issue was successfully created.' }
    end
  end

  def close_issue
    Rails.logger.info ">> GithubRepoController: delete issue"
    github_client = GitHubApi.new
    github_client.init_with_token(current_user.github_account.access_token)
    @github_repository = @project.github_repository

    unless @github_repository.nil?
      github_client.issues.update(@github_repository.owner, @github_repository.name, params[:issue_id], state: 'closed')
      redirect_to :back  , flash: { success: 'Github issue was successfully closed.' }
    end
  end


  private

    def find_project
      @project = Project.find(params[:project_id])
    end

    def init_github_api
      unless current_user.github_account.nil?
        token = current_user.github_account.access_token
        Rails.logger.info ">> GitthubRepoController: init API with token: #{token}"
          @github_api = GitHubApi.new
          @github_api.init_with_token(token)
      else
        redirect_to current_user, :flash => { :notice => 'Please link your account to a GitHub account!' }
      end
    end

    def init_github_api_with_project
      if @project.github_repository.nil? && current_user.github_account.nil?
        redirect_to current_user, :flash => { :notice => 'Please link your account to a GitHub account!' }

      elsif @project.github_repository.nil?
        token = current_user.github_account.access_token
        Rails.logger.info ">> GitthubRepoController: init API with token: #{token}"
          @github_api = GitHubApi.new
          @github_api.init_with_token(token)

      elsif @project.github_repository.user_id == current_user.id
        token = current_user.github_account.access_token
        Rails.logger.info ">> GitthubRepoController: init API with token: #{token}"
          @github_api = GitHubApi.new
          @github_api.init_with_token(token)

      else
        # GitHub API without token?
        user = User.find(@project.github_repository.user_id)
        token = user.github_account.access_token
        Rails.logger.info ">> GitthubRepoController: init API with foreign token: #{token}"
          @github_api = GitHubApi.new
          @github_api.init_with_token(token)
      end
    end
end



