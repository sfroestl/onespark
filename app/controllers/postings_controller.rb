class PostingsController < ApplicationController
  layout 'project'
  
  before_filter :find_project
  # GET /postings
  # GET /postings.json
  def index
    @postings = Posting.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @postings }
    end
  end

  # GET /postings/1
  # GET /postings/1.json
  def show
    @posting = Posting.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @posting }
    end
  end

  # GET /postings/new
  # GET /postings/new.json
  def new
    @posting = Posting.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @posting }
    end
  end

  # GET /postings/1/edit
  def edit
    @posting = Posting.find(params[:id])
  end

 # POST /postings
  # POST /postings.json
  def create

    Rails.logger.info ">> Posting Controller create Positng"
    Rails.logger.info "Topic #{params[:posting][:topic]}"
   
    Rails.logger.info "#{params[:posting]}"
    @posting = @project.postings.build(params[:posting])
    @posting.creator = current_user

    respond_to do |format|
      if @posting.save
        format.html { redirect_to :back, :flash => { :success => 'Posting was successfully created.' } }
        format.json { render json: @posting, status: :created, location: @posting }
      else
        format.js {  }
        format.html { render action: "new" }
        format.json { render json: @posting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /postings/1
  # PUT /postings/1.json
  def update
    @posting = Posting.find(params[:id])

    
    respond_to do |format|
      if @posting.update_attributes(params[:posting])
        format.html { redirect_to project_topics_path(@project), :flash => { :success =>'Posting was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @posting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /postings/1
  # DELETE /postings/1.json
  def destroy
    @posting = Posting.find(params[:id])
    
    @posting.destroy

    respond_to do |format|
      format.html { redirect_to :back, :flash => { :success => 'Posting was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private
    def find_project
      @project = Project.find(params[:project_id])
    end
end
