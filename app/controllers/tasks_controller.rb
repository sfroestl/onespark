class TasksController < ApplicationController
  layout 'project'
  before_filter :find_project
  # GET /tasks
  # GET /tasks.json
  
  def index
    @tasks = Task.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create

    Rails.logger.info "Worker #{params[:task][:worker]}"
    worker = User.find_by_username(params[:task][:worker])
    params[:task][:worker] = worker
    
    params[:task][:completed] = false

    Rails.logger.info ">> Task Controller new Task"
    Rails.logger.info "#{current_user.username}"
    Rails.logger.info "#{params[:task]}"

    @task = @project.tasks.build(params[:task])
    @task.creator = current_user
    
    respond_to do |format|
      if @task.save
        if @task.tasklist
          format.html { redirect_to project_tasklist_path(@project, @task.tasklist), :flash => { :success =>'Task was successfully updated.' } }
          format.json { head :no_content }
        else
          format.html { redirect_to project_tasklists_path(@project), :flash => { :success =>'Task was successfully updated.' } }
          format.json { head :no_content }
        end
      else
        format.js {  }
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])

    Rails.logger.info "Worker #{params[:task][:worker]}"
    worker = User.find_by_username(params[:task][:worker])
    params[:task][:worker] = worker

    Rails.logger.info">> Tasks update: #{params}"

    if params[:task][:completed].eql? "true"
      Rails.logger.info">> Task completed!"
      params[:task][:completed_at] = Time.now
      params[:task][:completed_by] = current_user.id
    elsif params[:task][:completed].eql? "false"
      Rails.logger.info">> Task reopend!"
      params[:task][:completed_at] = nil
      params[:task][:completed_by] = nil
    end

    respond_to do |format|
      if @task.update_attributes(params[:task])
        if @task.tasklist
          format.html { redirect_to project_tasklist_path(@project, @task.tasklist), :flash => { :success =>'Task was successfully updated.' } }
          format.json { head :no_content }
        else
          format.html { redirect_to project_tasklists_path(@project), :flash => { :success =>'Task was successfully updated.' } }
          format.json { head :no_content }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    
    @task.destroy

    respond_to do |format|
      format.html { redirect_to :back, :flash => { :success => 'Task was successfully deleted.' } }
      format.json { head :no_content }
    end
  end



  private

    def find_project
      @project = Project.find(params[:project_id])
    end

    def find_milestone
      if params[:milestone_id]
        @milestone = Milestone.find(params[:milestone_id])
      end
    end

    def find_project_milestones      
      @milestones = @project.milestones           
    end
end
