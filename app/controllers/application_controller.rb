class ApplicationController < ActionController::Base
  include ControllerAuthentication
  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      redirect_to root_url, :alert => exception.message
    else
      redirect_to login_url, :alert => exception.message
    end
  end
  protect_from_forgery
  helper_method :current_user

  def created(s); success(:created,s) end
  def deleted(s); success(:deleted,s) end
  def d(s); t(s).downcase end
  def dp(s); pl(s).downcase end
  def pl(s); t(s).match(/\w/) ? t(s).pluralize : t(s) end  
  def success(act,mdl); t("success.#{act}",:obj=>d(mdl)) end
  def success_p(act,mdl); t("success.#{act}",:obj=>dp(mdl)) end
  def success_p(act,owner,mdl); t("success.#{act}",:obj=>t(:possessive,:owner=>owner,:obj=>dp(mdl))) end
  def updated(s); success(:updated,s) end
  def updated_p(s); success_p(:updated,s) end
  def updated_p(s1,s2); success_p(:updated,s1,s2) end

  private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
end
