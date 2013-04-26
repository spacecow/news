module ApplicationHelper
  def chain(s1,s2); "#{s1.to_s}.#{s2.to_s}" end
  #def create(s); t2(:create,s) end
  def current_language; english? ? t(:japanese) : t(:english) end
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  def edit(s); t2(:edit,s) end
  def edit_p(s); tp2(:edit,s) end
  def ft(s); t("formtastic.labels.#{s.to_s}") end
  def lbl(s); chain(:label,s) end
  def new(s); t2(:new,s) end
  def notification(act); t("notice.#{act}") end
  def pl(s); t(s).match(/\w/) ? t(s).pluralize : t(s) end
  def present(array, klass=nil)
    if array.instance_of? Array
      object = array.shift
      parent = array.shift
      grandparent = array.shift
    else
      object = array
      parent = nil
      grandparent = nil
    end
    if object.class.superclass.superclass.to_s == "ActiveRecord::Base"
      klass ||= "#{object.class.superclass}Presenter".constantize
    else
      klass ||= "#{object.instance_of?(Class) ? object : object.class}Presenter".constantize
    end
    presenter = klass.new(object, parent, grandparent, self)
    yield presenter if block_given?
    presenter
  end
  def sure?; t('message.sure?') end
  def t2(s1,s2); t(lbl(s1), :obj => t(s2)) end
  def tp2(s1,s2); t(lbl(s1), :obj => pl(s2)) end
  def update(s); t2(:update,s) end
  def update_p(s); tp2(:update,s) end
  def verify(s); t2(:verify,s) end
  #def view(s); tp2(:view,s) end
  def view_own(s); tp2(:view_own,s) end

  def insert_header(s)
    ret = ""
    File.open("/www/htdocs#{s}", "r:iso-2022-jp").each do |line|
      ret += line
    end
    ret
  end

  def insert_menu(s)
    ret = ""
    File.open("/www/htdocs#{s}", "r:iso-2022-jp").each do |line|
      ret += line
    end
    ret
  end

  def verify_page; request.url =~ /comments\/verify/ end
  def sent_page; request.url =~ /comments\/\d+\/sent/ end
end
