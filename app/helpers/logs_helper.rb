module LogsHelper
  def pdf_chart_data
    @months.map do |month|
      {
        created_at: month.date,
        #pdf07: month.unique_category_log_count('pdf07'),
      }.merge(
      Hash[*Category.all.map(&:name).uniq.sort.select{|e| e =~ /pdf/}.map do |s|
        [s, month.unique_category_log_count(s)]
      end.flatten])
    end
  end

  def total_chart_data
    @months.map do |month|
      {
        created_at: month.date,
        #top_page: month.categories.where(name:'page_top').first.log_count,
        top_page: month.unique_category_log_count('page_top'),
        pdf: month.unique_category_log_count('pdf'),
      }
    end
  end
end
