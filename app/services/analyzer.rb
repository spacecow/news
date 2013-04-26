require 'assert'

class Analyzer
  PDF_SEARCH = ["GET /riecnews/main/#pdf.pdf HTTP", "GET /archive/publication/riecnewspdf/#pdf.pdf HTTP", "/activity/publication/riecnewspdf/#pdf.pdf"]
  
  #def add_log(s)
  #  assert_match s, /riecnews/
  #  assert_match s, / 200 /
  #  s =~ /^(.*) - - \[(.*?)\]/
  #  Log.create ip:$1, date:Log.parse_date($2)
  #end


  class << self
    def access_log_date_format date
      date.strftime "%d/%b/%Y"
    end
    def access_log_month_format date
      date.strftime "%b/%Y"
    end
    def file_month_format date
      date.strftime "%y%m"
    end
    def file_date_format date
      date.strftime "%y%m%d"
    end
      
    def riecnews_log_path
      "data/riecnews_log"
    end
    def access_log_path 
      "/usr/local/apache2/logs/www/access_log"
    end
  
    def beginning_of_this_month
      Time.zone.now.beginning_of_month.to_date
    end

    def category s
      if match = s.match(/.*\/(riecnews)_\D*(\d+)\.pdf/)
        riec, no = match.captures
        no = "0#{no}" if no.length == 1
        return "pdf#{no}" if no
      elsif ['/riecnews/index-j.shtml', '/riecnews', '/riecnews/'].include? s
        return 'page_top'
      end
    end

    def create_logs log
      init_count = Log.count
      log.split("\n").each do |line|
        ip, date, path = line.match(/^(.*) - - \[(.*?)\] "\w+ (.*) HTTP/).captures
        if(category = category path)
          date = Log.parse_date(date)
          month = Month.find_or_create_by_name file_month_format(date)
          log = Log.new ip:ip, date:date
          Category.find_or_create_by_name_and_month_id(category, month.id).logs << log
        end
      end
      p "Logs created: #{Log.count - init_count}"
    end

    def delete_logs month
      categories = Month.find_by_name(month).try(:categories)
      categories.destroy_all if categories
    end

    # * date is a string, hopefully in form of a date in the log
    # * date is a Date, converted to a string date
    def load_riecnews_access_log date
      date = access_log_date_format(date) if date.instance_of? Date
      assert_match(date, /^$|^(\d+\/)?\w{3}\/\d{4}$/)
      path = riecnews_log_path
      p "Load file: #{path} | grep #{date}"
      %x[cat "#{path}" | grep "#{date}"]
    end

    def month_intervals
      start = Time.zone.parse('2011-03-11').beginning_of_month.to_date
      finish = beginning_of_this_month
      Johan::Date.month_intervals start, finish
    end


    def populate_riecnews_access_log
      path = riecnews_log_path
      p "Creates file: #{path}"
      begin
        outfile = File.open(path, 'w')
        File.open(access_log_path, 'r').each do |line|
          line =~ /^.* - - \[.*\] "(?:GET|HEAD|POST|OPTIONS) (.*) HTTP/
          assert_not_nil $1
          outfile.write(line) if line =~ /riecnews/ if line =~ / 200 /
        end
      ensure
        outfile.close
      end
    end

    def save_riecnews_access_log log, outfile
      File.open(outfile, 'w') do |f|
        f.write log
      end
      p "Created file: #{outfile}"
    end

    def save_snapshot
      month_intervals.each do |month|
        save_snapshot_by_month file_month_format(month)
      end
    end

    def save_snapshot_by_month month
      assert_match month, /^\d{4}$/
      date = access_log_month_format Date.parse("#{month}01")
      path = riecnews_log_path
      outfile = "#{path}_#{month}"
      log = load_riecnews_access_log date
      save_riecnews_access_log log, outfile
      #Month.find_by_name(month).categories.delete_all
      delete_logs month
      create_logs log
    end

    def save_yesterdays_snapshot
      _yesterday = yesterday
      log = load_riecnews_access_log access_log_date_format(_yesterday)
      outfile = "#{riecnews_log_path}_#{file_date_format _yesterday}"
      save_riecnews_access_log log, outfile
      create_logs log
    end

    def unique_pdf_paths
      set = Set.new
      File.open(riecnews_log_path, 'r').each do |line|
        line =~ / ([\/\w]*\.pdf) /
        set.add $1 if $1 
      end
      set.to_a.sort.join("\r\n")
    end

    def yesterday
      (Time.zone.now - 1.day).to_date
    end
  end
end
