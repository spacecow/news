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
  def monthly_unique_hits(key); keyed_logs(key).map(&:ip).uniq.count end
  def total_hits; logs.count end
  def unique_hits; logs.map(&:ip).uniq.count end

  class << self
    def load(s=nil)
      %x[cat "#{path}" | grep "#{s}"].split("\n")
    end
    def log(cat,s=nil)
      logs = send("#{cat}_log_arr",s).map{|a| Log.new(:ip => a[0], :date => Log.load_date(a[1]), :category => cat)}
      ApacheAccessLog.new logs
    end
    def log_arr(cat,s=nil)
      send("#{cat}_log_raw",s).map do |line|
        data = line.match(/^(.*) - - \[(.*?)\]/)
        [data[1], data[2]]
      end
    end
    def path; raise NotImplementedError end
    def save(s); File.open(path,"w"){|f| f.write(s)} end
    def top_page_log; log("top_page") end
    def top_page_log_arr(s=nil); log_arr("top_page") end
    def top_page_log_raw(s=nil); top_page_search.map{|e| load(e)}.flatten end
    def top_page_search; raise NotImplementedError end
  end
end
