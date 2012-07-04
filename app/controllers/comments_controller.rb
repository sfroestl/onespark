class CommentsController < ApplicationController
  layout 'project'

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

    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, :notice => "Successfully created comment."
    else
      redirect_to @commentable, :notice => "Add a comment content."
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      redirect_to @comment, :notice  => "Successfully updated comment."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to comments_url, :notice => "Successfully destroyed comment."
  end


  private
    def find_commentable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          Rails.logger.info "STRING #{$1.classify.constantize.find(value)}"
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
