class CommentsController < ApplicationController
  load_and_authorize_resource :except => :verify

  def index
    @comments = Comment.all
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment = Comment.new
  end

  def verify
    p params
    @comment = Comment.new(params[:comment])
    
  end
  
  def create
    if current_user; @comment = current_user.comments.build(params[:comment])
    else @comment = Comment.new(params[:comment]) end
    if @comment.valid?
      redirect_to verify_comments_path(:comment => params[:comment])
#      redirect_to new_comment_path, :notice => created(:comment)
    else
      render :action => 'new'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      redirect_to new_comment_path, :notice  => updated(:comment)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to comments_url, :notice => deleted(:comment)
  end
end
