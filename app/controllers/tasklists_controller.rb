##
# The TasklistsController class
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012

class TasklistsController < ApplicationController
  layout 'project'

  # get the current project
  before_filter :find_project

  # GET /tasklists
  # GET /tasklists.json
  def index
    @tasklists = @project.tasklists

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasklists }
    end
  end

  # GET /tasklists/1
  # GET /tasklists/1.json
  def show
    @tasklist = Tasklist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tasklist }
    end
  end

  # GET /tasklists/new
  # GET /tasklists/new.json
  def new
    @tasklist = Tasklist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tasklist }
    end
  end

  # GET /tasklists/1/edit
  def edit
    @tasklist = Tasklist.find(params[:id])
  end

  # POST /tasklists
  # POST /tasklists.json
  def create
    @tasklist = @project.tasklists.build(params[:tasklist])
    @tasklist.creator = current_user

    respond_to do |format|
      if @tasklist.save
        format.html { redirect_to project_tasklist_path(@project, @tasklist), :flash => { :success => 'Tasklist was successfully created.' } }
        format.json { render json: @tasklist, status: :created, location: @tasklist }
      else
        format.html { render action: "new" }
        format.json { render json: @tasklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasklists/1
  # PUT /tasklists/1.json
  def update
    @tasklist = Tasklist.find(params[:id])

    respond_to do |format|
      if @tasklist.update_attributes(params[:tasklist])
        format.html { redirect_to project_tasklist_path(@project, @tasklist), :flash => { :success => 'Tasklist was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tasklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasklists/1
  # DELETE /tasklists/1.json
  def destroy
    @tasklist = Tasklist.find(params[:id])
    @tasklist.destroy

    respond_to do |format|
      format.html { redirect_to project_tasklists_url, :flash => { :success => 'Tasklist was successfully deleted.' } }
      format.json { head :no_content }
    end
  end
end
