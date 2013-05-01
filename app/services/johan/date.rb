module Johan
  class Date
    class << self
      def month_intervals start, finish
        months = []
        while start <= finish
          months << start
          start += 35.day
          start = start.beginning_of_month.to_date 
        end
        months
      end

      def interval(arr)
        (arr.first.to_date..arr.last.to_date).to_a
      end

      def tag s, date = nil, format = '%y%m%d'
        date = ::Date.today.strftime(format) if date.nil?
        date = date.strftime(format) if date.instance_of? ::Date
        "#{s}_#{date}"
      end
    end
  end
end
