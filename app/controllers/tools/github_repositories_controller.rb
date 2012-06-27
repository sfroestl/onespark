class Tools::GithubRepositoriesController < ApplicationController
  require 'tools/github/github_api'

  before_filter :find_project, except: [:index, :create_repo]
  before_filter :init_github_api, only: [:index, :create_repo]
  before_filter :init_github_api_with_project, except: [:index, :create_repo]
  
  # GET project/:id/tools/github_repositories
  # GET project/:id/tools/github_repositories.json
  def index
    @user = User.find_by_username(params[:user_id])
    github_account = @user.github_account
    @github_api = GitHubApi.new
    @github_api.init_with_token(github_account.access_token)
    
    unless github_account.nil?
      @user_github_repos = @github_api.repos.list
      # @repo_data = @github_api.repos.get(@github_repository.owner, @github_repository.name)
      
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user_github_repos }
      end
    end
  end

  # GET project/:id/tools/github_repositories/1
  # GET project/:id/tools/github_repositories/1.json
  def show
    @github_repository = @project.github_repository
    
    unless @github_repository.nil?
      @repo_data = @github_api.repos.get(@github_repository.owner, @github_repository.name)
      @repo_issues = @github_api.issues.list(user: @github_repository.owner, repo: @github_repository.name)
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @github_repository }
    end
  end

  # GET project/:id/tools/github_repositories/new
  # GET project/:id/tools/github_repositories/new.json
  def new
    @user_repositories = @github_api.repos.list
    Rails.logger.info ">> GitthubRepoController: user repos nil? #{@user_repositories.nil?}"

    # @tools_github_repository = Tools::GithubRepository.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tools_github_repository }
    end
  end

  # POST project/:id/tools/github_repositories
  # POST project/:id/tools/github_repositories.json
  def create
    @github_repository = @github_api.repos.get( params[:owner], params[:repository])
    
    Rails.logger.info ">> Chosen Repo: #{@github_repository.url}"
    
    @project.create_github_repository()
    respond_to do |format|
      if @project.create_github_repository(name: params[:repository], owner: params[:owner], url: @github_repository.url, user_id: current_user.id )
        format.html { redirect_to project_github_repository_url(@project), flash: { success: 'Github repository was successfully linked.' }}
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
      format.html { redirect_to project_github_repository_url(@project), flash: { success: 'Github repository was successfully unlinked.' } }
      format.json { head :no_content }
    end
  end

  def create_repo
    @user = User.find_by_username( params[:username] )
    @github_account = @user.github_account
    
    unless @github_account.nil?
      @github_api.repos.create( { name: params[:name], description: params[:description] } )
      redirect_to user_github_repositories_url(@user) , flash: { success: 'Github repository was successfully created.' }
    end
  end

  def create_issue
    @github_repository = @project.github_repository
    
    unless @github_repository.nil?
      @github_api.issues.create(@github_repository.owner, @github_repository.name, { title: params[:title], body: params[:body] })
      redirect_to project_github_repository_url(@project) , flash: { success: 'Github issue was successfully created.' }
    end
  end

  def close_issue
    @github_repository = @project.github_repository
    
    unless @github_repository.nil?
      @github_api.issues.update(@github_repository.owner, @github_repository.name, params[:issue_id], state: 'closed')
      redirect_to project_github_repository_url(@project) , flash: { success: 'Github issue was successfully closed.' }
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



