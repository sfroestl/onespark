class ProjectsController < ApplicationController
before_filter :get_all_projects

def new
  @project = Project.new
end

def index
end

def show
  @project = find_project(params[:id])
end

def create
    @project = Project.new(params[:project])
    if @project.save
      flash.now[:success] = "Project created!"
      get_all_projects
      render 'index'
    else
      flash.now[:error] = "Error! Project not created!"
      render 'new'
    end
end

def destroy
  if project = find_project(params[:id])
     project.destroy
     flash.now[:success] = "Your project has been deleted."
     get_all_projects
     render 'index'
  else
    flash.now[:error] = "No such project!"
    render 'index'
   end
 end
 
def edit
  @project = find_project(params[:id])
end 

def update
    @project = find_project(params[:id])
    if @project.update_attributes(params[:project])
      flash[:success] = "Project updated"
      get_all_projects
      render 'index'
    else
      render 'edit'
  end
end

private

  def get_all_projects
    @projects = Project.all
  end
  
  def find_project(id)
    Project.find(params[:id])
  end
end
