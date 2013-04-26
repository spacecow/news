module LogsHelper
  def months_chart_data
    @months.map do |month|
      {
        created_at: month.date,
        #top_page: month.categories.where(name:'page_top').first.log_count,
        top_page: month.category_log_count('page_top'),
        pdf01: month.category_log_count('pdf01'),
        pdf02: month.category_log_count('pdf02'),
        pdf03: month.category_log_count('pdf03'),
        pdf04: month.category_log_count('pdf04'),
        pdf05: month.category_log_count('pdf05'),
        pdf06: month.category_log_count('pdf06')
      }
    end
  end
end
