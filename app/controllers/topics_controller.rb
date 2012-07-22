class TopicsController < ApplicationController
  layout 'project'
  before_filter :find_project
  before_filter :find_topics

  # GET /topics
  # GET /topics.json
  def index

    respond_to do |format|
      format.html { render :layout => ! request.xhr? }
      format.json { render json: @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @topic = Topic.find(params[:id])
    @comments = find_topic_comments
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.json
  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = @project.topics.build(params[:topic])
    @topic.creator = current_user
    respond_to do |format|
      if @topic.save
        format.html { redirect_to project_topic_path(@project, @topic), :flash => { :success =>  'Topic was successfully created.' } }
        format.json { render json: @topic, status: :created, location: @topic }
      else
        format.html { render action: "new" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.json
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to project_topic_path(@project, @topic), :flash => { :success => 'Topic was successfully updated.' }}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to project_topics_path(@project) }
      format.json { head :no_content }
    end
  end


  private

  def find_project
    if (params[:project_id])
      @project = Project.find(params[:project_id])
    else
      @project = Topic.find(params[:id]).project
    end
  end

  def find_topics
    @topics = @project.topics
  end

  def find_topic_comments
    @topic.comments.all
  end
end
