 class BasePresenter
  def initialize(object, parent=nil, grandparent=nil, template)
    @object = object
    @parent = parent
    @grandparent = grandparent
    @template = template
  end

  def h; @template end

  def clear_div
    "<div class='clear'></div>".html_safe
  end

  def new_link
    dobject = @object.to_s.downcase
    dparent = @parent.class.to_s.downcase
    if h.can? :new, @object
      if dparent == 'nilclass'
        h.link_to h.new(dobject.to_sym), h.send("new_#{dobject}_path") 
      else
        h.link_to h.new(dobject.to_sym), h.send("new_#{dparent}_#{dobject}_path", @parent) 
      end
    end
  end
  def edit_link
    if @object.class.superclass.to_s == "ActiveRecord::Base"
      dobject = @object.class.to_s.downcase
    else
      dobject = @object.class.superclass.to_s.downcase
    end
    dparent = @parent.class.to_s.downcase
    if h.can? :edit, @object 
      if dparent == 'nilclass'
        h.link_to h.t(:edit), h.send("edit_#{dobject}_path", @object), class:'edit_link' 
      else
        h.link_to h.t(:edit), h.send("edit_#{dparent}_#{dobject}_path", @parent,@object), class:'edit_link' 
      end
    end
  end
  def delete_link
    dcase = @object.class.to_s.downcase
    dparent = @parent.class.to_s.downcase
    #if dparent == 'nilclass'
    #  h.link_to h.t(:delete), @object, method: :delete, data:{confirm:h.sure?} #if h.can? :destroy, @object 
    #else
      h.link_to h.t(:delete), [@parent, @object], method: :delete, data:{confirm:h.sure?} if h.can? :destroy, @object 
    #end
  end

  def timestamp
    h.content_tag(:div, class:'timestamp') do
      h.time_ago_in_words(@object.updated_at)+" ago"
    end
  end

  class << self
    def presents(name, parent=nil, grandparent=nil)
      define_method(name) do
        @object
      end
      define_method(parent) do
        @parent
      end unless parent.nil?
      define_method(grandparent) do
        @grandparent
      end unless grandparent.nil? 
    end
  end
end
