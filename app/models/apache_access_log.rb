class ApacheAccessLog < LogAnalyzer

  def merge(log); ApacheAccessLog.new logs.concat(log.logs) end

  class << self
    def path; "/usr/local/apache2/logs/www/access_log" end
    def root_logs; raise NotImplementedError end
    def root_logs_arr; raise NotImplementedError end
    def root_logs_raw; raise NotImplementedError end
    def top_page_search; raise NotImplementedError end
  end
end
