require 'assert'

class CategoryPresenter < BasePresenter
  presents :category

  def categories _categories
    h.render _categories.sort_by(&:name)
  end

  def counts
    h.content_tag :span, class: :counts do
      name = category.name
      assert_match name, /pdf|page_top/
      if name =~ /pdf/
        "#{name.capitalize} downloads: #{category.log_count} (#{category.unique_log_count})" 
      else
        "Top page hits: #{category.log_count} (#{category.unique_log_count})"
      end
    end
  end

end
