class TasksController < ApplicationController
  layout 'project'
  before_filter :find_project
  before_filter :find_project_milestones
  before_filter :find_milestone
  # GET /tasks
  # GET /tasks.json
  
  # def index
  #   @tasks = Task.all

  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @tasks }
  #   end
  # end

  # # GET /tasks/1
  # # GET /tasks/1.json
  # def show
  #   @task = Task.find(params[:id])

  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @task }
  #   end
  # end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    
    @task = @project.tasks.build

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
    
    if params[:project_id] and params[:milestone_id]
      Rails.logger.info ">> Task Controller new Task with milestone | #{params[:project_id]} | #{params[:milestone_id]}"
      @task = @project.tasks.build(params[:task])
      @task.creator = current_user
      @task.milestone = @milestone
      redirect_path = project_milestone_url(@project, @milestone)
      Rails.logger.info ">> #{redirect_path}"
    
    else
      Rails.logger.info ">> Task Controller new Task without milestone | #{current_user}"
      @task = @project.tasks.build(params[:task])
      @task.creator = current_user
      redirect_path = project_url(@project)
      Rails.logger.info ">> #{redirect_path}"
    end
    

    respond_to do |format|
      if @task.save
        format.html { redirect_to redirect_path, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])
    
    if @project && @milestone
      redirect_path = project_milestone_url[@project, @milestone]
    else
      redirect_path = project_milestones_url(@project)
    end
    
    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
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
      format.html { redirect_to tasks_url }
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
