class MilestonesController < ApplicationController
  def create
    @milestones = Milestone.new(params[:milestones])
    if @milestones.save
      redirect_to @milestones, :notice => "Successfully created milestones."
    else
      render :action => 'new'
    end
  end

  def update
    @milestones = Milestone.find(params[:id])
    if @milestones.update_attributes(params[:milestones])
      redirect_to @milestones, :notice  => "Successfully updated milestones."
    else
      render :action => 'edit'
    end
  end

  def edit
    @milestones = Milestone.find(params[:id])
  end

  def index
    @milestones = Milestone.all
  end

  def show
    @milestones = Milestone.find(params[:id])
  end

  def new
    @milestones = Milestone.new
  end

  def destroy
    @milestones = Milestone.find(params[:id])
    @milestones.destroy
    redirect_to milestones_url, :notice => "Successfully destroyed milestones."
  end
end
