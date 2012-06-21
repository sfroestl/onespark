class MilestonesController < ApplicationController

  before_filter :find_project

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
    @milestone = Milestone.find(params[:id])
    if @milestone.update_attributes(params[:milestone])
      redirect_to project_milestone_path(@project, @milestone), :flash => { :success => "Successfully updated milestone." }
    else
      render :action => 'edit'
    end
  end

  def edit
    @milestone = Milestone.find(params[:id])
  end

  def index
    @milestones = @project.milestones
  end

  def show
    @milestone = Milestone.find(params[:id])
    @project ||= @milestone.project
  end

  def new
    @milestone = Milestone.new
  end

  def destroy
    @milestone = Milestone.find(params[:id])
    @milestone.destroy
    redirect_to :action => 'index', :flash => { :success => "Successfully deleted milestones." }
  end


  private

  def find_project
    @project = Project.find(params[:project_id])
  end
end
