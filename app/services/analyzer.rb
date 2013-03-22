require 'assert'

class Analyzer
  def add_log(s)
    assert_match s, /riecnews/
    assert_match s, / 200 /
    s =~ /^(.*) - - \[(.*?)\]/
    Log.create ip:$1, date:Log.parse_date($2)
  end


  class << self
    def access_log_date_format date
      date.strftime "%d/%b/%Y"
    end
    def access_log_month_format date
      date.strftime "%b/%Y"
    end
  
    def create_logs log
      log.split("\n").each do |line|
        line =~ /^(.*) - - \[(.*?)\]/
        Log.create! ip:$1, date:Log.parse_date($2)
      end
    end

    def file_month_format date
      date.strftime "%y%m"
    end
      
    def load_access_log date
      date = access_log_date_format(date) if date.instance_of? Date
      assert_match(date, /^(\d+\/)?\w{3}\/\d{4}$/)
      p "-----------------==LOADES FILE=----------"
      %x[cat "#{path}" | grep "#{date}" | grep riecnews | grep " 200 "].strip
    end

    def month_intervals
      start = Time.zone.parse('2011-03-11').beginning_of_month.to_date
      finish = beginning_of_this_month
      Johan::Date.month_intervals start, finish
    end

    def path
      "/usr/local/apache2/logs/www/access_log"
    end

    def save_access_log log, month
      assert_match month, /^\d{4}$/
      p "-----------------==SAVES FILE=----------"
      File.open("data/riecnews_access_log_#{month}","w") do |f| 
        f.write(log)
      end
    end

    def save_snapshot
      month_intervals.each do |month|
        log = load_access_log access_log_month_format(month)
        save_access_log log, file_month_format(month)
      end
    end

    def beginning_of_this_month
      Time.zone.now.beginning_of_month.to_date
    end
  end
end
