class ProjectsController < ApplicationController
  before_filter :get_all_projects
  before_filter :signed_in_user

  # GET /projects
  # GET /projects.json
  def index
    # TODO: make project only accesible for admin and invited users
    @projects = Project.find(:all, order: "due_date")
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end
  
  # GET /projects/1
  # GET /projects/1.json
  def show
     @project = find_project(params[:id])
     
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
        format.html { redirect_to @project, :flash => { :success => "Project created!" } }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new", :flash => { :error => "Project not created!" }  }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tests/1
  # DELETE /tests/1.json
  def destroy
    @project = find_project(params[:id])
    @project.destroy
      
    respond_to do |format|
      format.html { redirect_to projects_path, :flash => { :success => "Your project has been deleted." }}
      format.json { head :no_content }
    end
  end
 
   # GET /projects/1/edit
  def edit
    @project = find_project(params[:id])
  end 

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = find_project(params[:id])
    
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

    def get_all_projects
      @projects = Project.all
    end
  
    def find_project(id)
      Project.find(params[:id])
    end
end
