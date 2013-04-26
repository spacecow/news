class MonthPresenter < BasePresenter
  presents :month

  def categories
    h.render 'categories/categories', categories:month.categories
  end

  def months months
    h.render months.sort_by(&:name)
  end

  def subtitle
    h.content_tag :h3, class: :subtitle do
      month.title
    end
  end
end
