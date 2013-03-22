class CommentPresenter < BasePresenter
  presents :comment

  def form
    h.render 'comments/form', comment:comment
  end

  def form_field s, captcha
    #h.content_tag :li, class: :string do
    #  h.negative_label_tag(captcha, s, h.ft(s)) +
    #  h.negative_text_field_tag(captcha, s)
    #end
    h.render 'comments/captcha_form_field', s:s, captcha:captcha, errors:comment.errors[s]
  end

  def captcha_form(captcha)
    h.content_tag :div, class:'form' do
      h.render 'comments/captcha_form', comment:comment, captcha:captcha
    end
  end

  def info
    h.content_tag :ul, class: :info do
      Comment::ATTRIBUTES.map do |s|
        public_send("list_#{s}")
      end.join.html_safe
    end
  end

  def title(s)
    h.content_tag :div, class: :title do
      s
    end
  end

  private

    Comment::ATTRIBUTES.each do |s|
      define_method "list_#{s}" do
        list_attribute s
      end
    end
    def list_attribute(s)
      h.render 'comments/list_attribute', label:h.t("formtastic.labels.#{s}"), content:comment.public_send(s)
    end
end
