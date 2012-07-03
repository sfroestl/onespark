class MilestonesController < ApplicationController
  layout 'project'
  before_filter :find_project
  before_filter :find_project_milestones
  before_filter :find_milestone, except: [:new, :create, :index]
  before_filter :find_milestone_tasks, except: [:new, :create, :index]
  before_filter :find_all_tasks, only: [:index]

  def create

    @milestone = @project.milestones.build(params[:milestone])
    @milestone.user = current_user
    if @milestone.save
      redirect_to :action => 'index', :flash => { :success => "Milestone created!" }
    else
      render :action => 'new'
    end
  end

  def update
    if @milestone.update_attributes(params[:milestone])
      redirect_to project_milestone_path(@project, @milestone), :flash => { :success => "Successfully updated milestone." }
    else
      render :action => 'edit'
    end
  end

  def edit
  end

  def index
  end

  def show    
    @project ||= @milestone.project
  end

  def new
    @milestone = Milestone.new
  end

  def destroy    
    @milestone.destroy
    redirect_to :action => 'index', :flash => { :success => "Successfully deleted milestones." }
  end


  private

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_project_milestones
    @milestones = @project.milestones    
  end

  def find_tasks
    @tasks = @milestone.tasks
  end

  def find_milestone
    @milestone = Milestone.find(params[:id])
  end

  def find_milestone_tasks
    @tasks = @milestone.tasks
  end

  def find_all_tasks
    @tasks = @project.tasks
  end
end
