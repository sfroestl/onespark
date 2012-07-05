class MilestonesController < ApplicationController
  layout 'project'
  before_filter :find_project
  before_filter :find_milestone, only: [:show]

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


  def show
    @project ||= @milestone.project

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def index
    Rails.logger.info ">> Milestones of Project: #{@project.title}"
    @task = Task.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @project.milestones }
    end
  end

  def show    
    
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

  def find_milestone
    @milestone = Milestone.find(params[:id])
  end
end
