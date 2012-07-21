class ProjectsController < ApplicationController
  layout 'project', except: [:index, :new, :create]
  # layout 'all_projects', only: [:index]
  # before_filter :get_all_projects
  before_filter :signed_in_user
  before_filter :find_user_projects
  before_filter :all_projects_of_user

  # before_filter :project_admins, only: [:update]
  # before_filter :project_writers, only: [:update]
  # before_filter :project_readers, except: [:index]
  # before_filter :setup_user_friends, only: [:show]


  # GET /projects
  # GET /projects.json
  def index
    # TODO: make project only accesible for admin and invited users
    @project = Project.new
    respond_to do |format|
      format.html {  }
      format.json { render json: @projects }
    end
  end
  
  # GET /projects/1
  # GET /projects/1.json
  def show
     @project = Project.find(params[:id])
     
     respond_to do |format|
       format.html # show.html.erb
       format.json { render json: @project}
     end
  end
  
  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = current_user.projects.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

 
  # POST /projects
  # POST /projects.json
  def create

    @project = current_user.projects.build(params[:project])
    
    respond_to do |format|

      if @project.save
        # @project.project_coworkers.create(user_id: current_user.id, permission: 3) # Save user to admins
        format.html { redirect_to @project, :flash => { :success => "Project created!" } }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render 'index', :flash => { :notice => "Project not created!" }  }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tests/1
  # DELETE /tests/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
      
    respond_to do |format|
      format.html { redirect_to projects_path, :flash => { :success => "Your project has been deleted." }}
      format.json { head :no_content }
    end
  end
 
   # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end 

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])
    
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, :flash => { :success => "Project updated" } }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in!"
      end
    end

    # def get_all_projects
    #   @projects = Project.all
    # end

    def find_user_projects
      @projects = Project.by_user(current_user) unless current_user.nil?
    end

    def all_projects_of_user
      @collab_projects = current_user.project_permissions unless  current_user.nil?
    end

    def project_admins
      @project = Project.find(params[:id])
      @admins = @project.admins
      ">> User: #{current_user.username} in #{@admins}"
      render 'public/403' unless @admins.include?(current_user)
    end

    def project_writers
      @project = Project.find(params[:id])
      @writers = @project.writers
      render 'public/403' unless @writers.include?(current_user)
    end

    def project_readers
      @project = Project.find(params[:id])
      @readers = @project.readers
      Rails.logger.info ">> User: #{current_user.username} in #{@readers}"
      render 'public/403' unless @readers.include?(current_user)
    end

    def project_permissionless
    end
end
