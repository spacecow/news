class LogAnalyzer
  def keyed_logs; logs.group_by(&:month_no) end
  def logs; @logs end
  def monthly_total_hits_arr
    keyed_logs.keys.sort.map do |key|
      monthly_total_hits(key)
    end
  end
  def monthly_total_hits(key); keyed_logs[key].count end
  def monthly_unique_hits_arr
    keyed_logs.keys.sort.map do |key|
      monthly_unique_hits(key)
    end
  end
  def monthly_unique_hits(key); keyed_logs[key].map(&:ip).uniq.count end
  def total_hits; logs.count end
  def unique_hits; logs.map(&:ip).uniq.count end

  class << self
    def load(s=nil); %x[cat "#{path}" | grep "#{s}"].split("\n") end
    def logs(cat)
      logs = send("#{cat}_logs_arr").map{|a| Log.new(:ip => a[0], :date => Date.parse(a[1]))}
      ApacheAccessLog.new logs
    end
    def logs_arr(cat)
      send("#{cat}_logs_raw").map do |line|
        data = line.match(/^(.*) - - \[(.*?)\]/)
        [data[1], data[2]]
      end
    end
    def path; raise NotImplementedError end
    def save(s); File.open(path,"w"){|f| f.write(s)} end
    def top_page_logs; logs("top_page") end
    def top_page_logs_arr; logs_arr("top_page") end
    def top_page_search; raise NotImplementedError end
  end
end
