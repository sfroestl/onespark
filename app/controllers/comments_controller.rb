##
# The CommentsController class
#
# Author::    Sebastian Fröstl  (mailto:sebastian@froestl.com)
# Last Edit:: 21.07.2012

class CommentsController < ApplicationController

  layout 'project', except: [:edit]

  def index
    @commentable = find_commentable
    @project = @commentable.project
    @comments = @commentable.comments
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment = Comment.new
  end

  def create
    @request_url = request.env['HTTP_REFERER']

    Rails.logger.info "COMMENTS: Requesturl: #{@request_url}"
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.js { }
        format.html { redirect_to :back, :flash => { :success => "Successfully created comment." } }
        format.json { render json: @comment }
      else
        format.js { }
        format.html { redirect_to :back, :flash => { :error => "Could not create comment." } }
        format.json { render json: comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable

    respond_to do |format|
      format.html # edit.html.erb
      format.js { }
    end

  end

  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to :back, :flash => { :success => "Successfully updated comment." } }
      else
        format.html { render  :action => 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
        format.js { }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      foramat.html { redirect_to :back, :notice => "Successfully destroyed comment." }
    end
  end


  private
  # finds the commentable resource
    def find_commentable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          Rails.logger.info "Commentable #{$1.classify.constantize.find(value)}"
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end

end
