require File.dirname(__FILE__) + '/../spec_helper'

def controller_actions(controller)
  Rails.application.routes.routes.inject({}) do |hash, route|
    hash[route.requirements[:action]] = route.verb.downcase if route.requirements[:controller] == controller && !route.verb.nil?
    hash
  end
end

describe CommentsController do
  comments_controller_actions = controller_actions("comments")

  before(:each) do
    @comment = Factory(:comment)
  end

  describe "a user is not logged in" do
    before(:each) do
      @user = Factory(:user)
    end
    
    comments_controller_actions.each do |action,req|
      if action=="index"
        it "should reach the #{action} page" do
          send("#{req}", "#{action}", :id => @comment.id)
          response.redirect_url.should_not eq(login_url)
        end
      else
        it "should not reach the #{action} page" do
          send("#{req}", "#{action}", :id => @comment.id)
          response.redirect_url.should eq(login_url)
        end
      end
    end
  end

  describe "a member is logged in" do
    before(:each) do
      @user = Factory(:user, :roles_mask=>8)
      session[:user_id] = @user.id
    end
    
    comments_controller_actions.each do |action,req|
      if %w(new create show index).include?(action)
        it "should reach the #{action} page" do
          send("#{req}", "#{action}", :id => @comment.id)
          response.redirect_url.should_not eq(root_url)
        end
      else
        it "should not reach the #{action} page" do
          send("#{req}", "#{action}", :id => @comment.id)
          response.redirect_url.should eq(root_url)
        end
      end
    end    
  end

  describe "a mini-admin is logged in" do
    before(:each) do
      @user = Factory(:user, :roles_mask=>4)
      session[:user_id] = @user.id
    end
    
    comments_controller_actions.each do |action,req|
      if %w(new create show index edit update).include?(action)
        it "should reach the #{action} page" do
          send("#{req}", "#{action}", :id => @comment.id)
          response.redirect_url.should_not eq(root_url)
        end
      else
        it "should not reach the #{action} page" do
          send("#{req}", "#{action}", :id => @comment.id)
          response.redirect_url.should eq(root_url)
        end
      end
    end    
  end  

  describe "an admin is logged in" do
    before(:each) do
      @user = Factory(:user, :roles_mask=>2)
      session[:user_id] = @user.id
    end
    
    comments_controller_actions.each do |action,req|
      it "should reach the #{action} page" do
        send("#{req}", "#{action}", :id => @comment.id)
        response.redirect_url.should_not eq(root_url)
      end
    end    
  end

  describe "a god has come down to Earth" do
    before(:each) do
      @user = Factory(:user, :roles_mask=>1)
      session[:user_id] = @user.id
    end
    
    comments_controller_actions.each do |action,req|
      it "should reach the #{action} page" do
        send("#{req}", "#{action}", :id => @comment.id)
        response.redirect_url.should_not eq(root_url)
      end
    end    
  end  
end
