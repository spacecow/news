class CommentsController < ApplicationController
  load_and_authorize_resource

  def index
    @comments = Comment.all
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment.name = current_user_name
    @comment.email = current_user_email
    @comment.affiliation = current_user_affiliation
  end

  def validate
    load_comment_depending_on_user
    if @comment.valid?
      flash[:notice] = notification(:contents_correct_for_sending?)
      redirect_to verify_comments_path(:comment => params[:comment])
    else
      render :action => 'new'
    end
  end

  def verify
    @comment = Comment.new(params[:comment])    
  end
  
  def create
    load_comment_depending_on_user
    if @comment.save
      CommentMailer.comment_confirmation(@comment).deliver
      flash[:notice] = notification(:thank_you_for_sending)
      redirect_to new_comment_path
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    if @comment.update_attributes(params[:comment])
      redirect_to comments_path, :notice  => updated(:comment)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to comments_url, :notice => deleted(:comment)
  end

  private

    def load_comment_depending_on_user
      if current_user; @comment = current_user.comments.build(params[:comment])
      else @comment = Comment.new(params[:comment]) end
    end
end
