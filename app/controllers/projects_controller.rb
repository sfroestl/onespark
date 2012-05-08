class ProjectsController < ApplicationController

def new
  @projects = Project.all
  @project = Project.new
end

def index
  @projects = Project.all
end

def show
  @projects = Project.all
  @project = Project.find(params[:id])
end



end
