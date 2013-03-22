class LogAnalyzer
  def initialize(logs)
    @logs = logs
  end

  def keyed_logs(key=nil)
    if key.nil?
      logs.group_by(&:month_no)
    else
      send("keyed_logs")[key] || []
    end
  end
  def logs; @logs end
  def monthly_total_hits_arr
    keyed_logs.keys.sort.map do |key|
      monthly_total_hits(key)
    end
  end
  def monthly_total_hits(key); keyed_logs(key).count end
  def monthly_unique_hits_arr
    keyed_logs.keys.sort.map do |key|
      monthly_unique_hits(key)
    end
  end
  def monthly_unique_hits(key)
    keyed_logs(key).map(&:ip).uniq.count 
  end
  def total_hits; logs.count end
  def unique_hits; logs.map(&:ip).uniq.count end

  class << self
    def load_access_log date
      date = date.strftime("%d/%b/%Y") unless date.nil?
      %x[cat "#{path}" | grep "#{date}" | grep riecnews | grep " 200 "]
    end
    def load_snapshot(s, date=nil, format='%y%m%d')
      date = ::Date.today.strftime(format) if date.nil?
      date = Date.parse(date) if date.instance_of? String
      file = Johan::Date.tag(path.split('/').last, date) unless date.nil?
      %x[cat "data/#{file}" | grep "#{s}"].split("\n")
    end
    def log(category, s=nil, date=nil)
      logs = send("#{category}_log_arr",s,date).map{|a| Log.new(:ip => a[0], :date => Log.load_date(a[1]), :category => category)}
      ApacheAccessLog.new logs
    end
    def log_arr(cat, s=nil, date=nil)
      send("#{cat}_log_raw", s, date).map do |line|
        data = line.match(/^(.*) - - \[(.*?)\]/)
        [data[1], data[2]]
      end
    end
    def path; raise NotImplementedError end
    def save_snapshot(date=nil, format='%y%m%d')
      date = Date.parse(date) if date.instance_of? String
      s = load_access_log date
      date = ::Date.today.strftime(format) if date.nil?
      new_path = Johan::Date.tag(path.split('/').last, date)
      File.open("data/#{new_path}","w"){|f| f.write(s)} 
    end
    def top_page_log(date=nil)
      log("top_page", nil, date)
    end
    def top_page_log_arr(s=nil, date=nil)
      log_arr("top_page", s, date)
    end
    def top_page_log_raw(s=nil, date=nil)
      top_page_search.map{|e| load_snapshot(e, date)}.flatten
    end
    def top_page_search; raise NotImplementedError end
  end
end
