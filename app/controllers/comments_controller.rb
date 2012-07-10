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

  # def create
  #   # Rails.logger.info ">> Commentable: #{find_commentable}"
  #   Rails.logger.info ">> Commentable Riderict: #{request.fullpath}"

  #   @commentable = find_commentable_by_hidden_field
  #   @comment = @commentable.comments.build(content: params[:comment][:content])
  #   @comment.user = current_user
  #   if @comment.save
  #     redirect_to params[:comment][:redirect_url], :notice => "Successfully created comment."
  #   else
  #     redirect_to params[:comment][:redirect_url], :notice => "Add a comment content."
  #   end
  # end

  def create
    # if
    @request_url = request.env['HTTP_REFERER']
    # else
    
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
    def find_commentable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          Rails.logger.info "Commentable #{$1.classify.constantize.find(value)}"
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end

    def find_commentable_by_hidden_field
      Rails.logger.info ">> Commentable: #{params[:comment][:commentable_name]}"
      name = params[:comment][:commentable_name]
      pname = name + '_id'
      id = params[pname.to_sym].to_i
      Rails.logger.info ">> symbol #{pname.to_sym}"
      Rails.logger.info ">> Value #{id}"
      return name.classify.constantize.find(id)
    end

end
