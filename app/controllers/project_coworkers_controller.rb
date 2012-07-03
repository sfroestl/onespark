class ProjectCoworkersController < ApplicationController
  layout 'project'
  before_filter :find_project
  before_filter :project_permisions
  before_filter :get_project_coworkers, only: [:index]

  def create
    user = User.find_by_username(params[:username])
    Rails.logger.info ">> Adding user: params[:username] to project #{@project.title}."
    if user.nil?         
      flash[:notice] = "No such user found." 
      redirect_to :action => 'index'
      return
    elsif check_if_owner(@project, user)
      flash[:notice] = "It's your project!" 
      redirect_to :action => 'index'
      return
    end

    

    if ProjectCoworker.exists?(@project, user)
      Rails.logger.info "already existing"
      flash[:notice] = "#{user.username} is already a project coworker." 
      redirect_to :action => 'index'
    
    elsif @project_coworker = @project.project_coworkers.create(user_id: user.id, permission: params[:coworker][:permission])
      Rails.logger.info ">> Adding user: #{user.username} to project #{@project.title}. Permission: #{params[:coworker][:permission]}"
      flash[:success] = "Successfully added project coworker." 
      redirect_to :action => 'index'
    
    else
      Rails.logger.info "false"
      flash[:error] = "Error creating project coworker." 
      render :action => 'index'
    end
  end

  def update
    @project_coworker = ProjectCoworker.find(params[:id])
    if @project_coworker.update_attributes(params[:project_coworker])
      flash[:success] = "Successfully updated project coworker."
      redirect_to @project_coworker
    else
      render :action => 'edit'
    end
  end

  # def edit
  #   @project_coworker = ProjectCoworker.find(params[:id])
  # end

  def index
    # @project_coworkers = ProjectCoworker.by_project(@project) unless @project.nil?
    @project_coworkers = get_project_coworkers
    @project_admins = get_project_admins
    @project_readers = get_project_readers
  end

  # def show
  #   @project_coworker = ProjectCoworker.find(params[:id])
  # end

  # def new
  #   @project_coworker = ProjectCoworker.new
  # end

  def destroy
    user = User.find_by_username(params[:id])
    Rails.logger.info ">> Removing coworker: #{user.username} from project #{@project.title}"

    if ProjectCoworker.exists?(@project, user)
      project_coworker = ProjectCoworker.find_by_project_id_and_user_id(@project, user)
    
      @project.project_coworkers.destroy(project_coworker.id)
      flash[:success] =  "Successfully removed project coworker."
      redirect_to :action => 'index'
    else
      flash[:error] = "Unable removed project coworker."
      redirect_to :action => 'index'
    end

  end

  private
    def check_if_owner(project, user)
      project.user.id == user.id
    end

    def find_project
      @project = Project.find(params[:project_id])
    end

    def project_permisions 
      @permissions = Project::PERMISSIONS
    end

    def get_project_coworkers
      @project.writers
    end

    def get_project_admins 
      @project.admins
    end

    def get_project_readers
      @project.readers
    end
end
