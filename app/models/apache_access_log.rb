class ApacheAccessLog < LogAnalyzer
  SEARCH = ["GET /riecnews/index-j.shtml HTTP/1.1","GET /riecnews HTTP/1.1","GET /riecnews/ HTTP/1.1"]
  def initialize(logs)
    @logs = logs
  end

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
    def path; "/usr/local/apache2/logs/www/access_log" end
    def riecnews_root_logs
      logs = riecnews_root_logs_arr.map{|s| Log.new(s)}
      ApacheAccessLog.new logs
    end
    def riecnews_root_logs_arr
      riecnews_root_logs_raw.map do |line|
        data = line.match(/^(.*) - - \[(.*?)\]/)
        [data[1], data[2]]
      end
    end
    def riecnews_root_logs_raw; SEARCH.map{|e| load(e)}.flatten end
  end
end
