class CommentsController < ApplicationController
  before_filter :setup_negative_captcha, :only => [:new, :validate]
  skip_load_resource :only => [:validate,:create]
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
    load_captcha_comment_depending_on_user
    if @captcha.valid? && @comment.valid?
      redirect_to verify_comments_path(:comment => @captcha.values)
    else
      #flash[:notice] = @captcha.error if @captcha.error
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
      redirect_to sent_comment_path(@comment)
    else
      render :action => 'new'
    end
  end

  def sent    
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

    def load_captcha_comment_depending_on_user
      if current_user; @comment = current_user.comments.build(@captcha.values)
      else @comment = Comment.new(@captcha.values) end
    end
    def load_comment_depending_on_user
      if current_user; @comment = current_user.comments.build(params[:comment])
      else @comment = Comment.new(params[:comment]) end
    end

    def setup_negative_captcha
      @captcha = NegativeCaptcha.new(
        :secret => "testing", #A secret key entered in environment.rb.  'rake secret' will give you a good one.
        :spinner => request.remote_ip, 
        :fields => [:name, :email, :affiliation, :content], #Whatever fields are in your form 
        :params => params)
    end
end
