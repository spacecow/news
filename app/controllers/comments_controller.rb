class CommentsController < ApplicationController
  load_and_authorize_resource

  def index
    @comments = Comment.all
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
  end

  def validate
    if current_user; @comment = current_user.comments.build(params[:comment])
    else @comment = Comment.new(params[:comment]) end
    if @comment.valid?
      flash[:notice] = created(:comment)
      redirect_to verify_comments_path(:comment => params[:comment])
    else
      render :action => 'new'
    end
  end

  def verify
    @comment = Comment.new(params[:comment])    
  end
  
  def create
    if current_user; @comment = current_user.comments.build(params[:comment])
    else @comment = Comment.new(params[:comment]) end
    if @comment.save
      flash[:notice] = t('message.thank_you_for_sending')
      redirect_to new_comment_path
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
