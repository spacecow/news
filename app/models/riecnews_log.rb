class RiecnewsLog < ApacheAccessLog
  PDF_SEARCH = ["GET /riecnews/main/#pdf.pdf HTTP", "GET /archive/publication/riecnewspdf/#pdf.pdf HTTP"]
  TOP_PAGE_SEARCH = ["GET /riecnews/index-j.shtml HTTP","GET /riecnews HTTP","GET /riecnews/ HTTP"]

  class << self
    def save_and_log_yesterdays_snapshot
      yesterday = Date.yesterday
      save_snapshot yesterday 
      log_snapshot yesterday
    end

    def save_and_log_snapshot
      save_snapshot
      log_snapshot 
    end

    def log_snapshot(date=nil)
      @log = RiecnewsLog.top_page_log date
      @pdflog1 = RiecnewsLog.pdf_log("riecnews_no01", date)
      @pdflog2 = RiecnewsLog.pdf_log("riecnews_no02", date)
      @pdflog3 = RiecnewsLog.pdf_log("riecnews_no03", date)
      @pdflog4 = RiecnewsLog.pdf_log("riecnews_no04", date)
      @pdflog5 = RiecnewsLog.pdf_log("riecnews_no05", date)
      @pdflog6 = RiecnewsLog.pdf_log("riecnews_no06", date)
      @pdflog7 = RiecnewsLog.pdf_log("riecnews_no07", date)
      @log.logs.each{|log| log.save} 
      @pdflog1.logs.each{|log| log.save} 
      @pdflog2.logs.each{|log| log.save} 
      @pdflog3.logs.each{|log| log.save} 
      @pdflog4.logs.each{|log| log.save} 
      @pdflog5.logs.each{|log| log.save} 
      @pdflog6.logs.each{|log| log.save} 
      @pdflog7.logs.each{|log| log.save} 
    end

    def pdf_log(s, date=nil)
      data = s.match(/(\d+)/)
      log("pdf#{data[1]}", s, date)
    end
    def pdf01_log_raw(s, date=nil)
      PDF_SEARCH.map{|e| load_snapshot(e.gsub(/#pdf/,s), date)}.flatten.select{|e| e=~/\s200\s/} +
      PDF_SEARCH.map{|e| load_snapshot(e.gsub(/#pdf/,s.gsub(/0/,'')), date)}.flatten.select{|e| e=~/\s200\s/}
    end
    def pdf02_log_raw(s=nil, date=nil)
      PDF_SEARCH.map{|e| load_snapshot(e.gsub(/#pdf/,s), date)}.flatten.select{|e| e=~/\s200\s/} +
      PDF_SEARCH.map{|e| load_snapshot(e.gsub(/#pdf/,s.gsub(/0/,'')), date)}.flatten.select{|e| e=~/\s200\s/}
    end
    def pdf03_log_raw(s=nil, date=nil)
      PDF_SEARCH.map{|e| load_snapshot(e.gsub(/#pdf/,s), date)}.flatten.select{|e| e=~/\s200\s/} +
      PDF_SEARCH.map{|e| load_snapshot(e.gsub(/#pdf/,s.gsub(/0/,'')), date)}.flatten.select{|e| e=~/\s200\s/}
    end
    def pdf04_log_raw(s=nil, date=nil)
      PDF_SEARCH.map{|e| load_snapshot(e.gsub(/#pdf/,s), date)}.flatten.select{|e| e=~/\s200\s/} +
      PDF_SEARCH.map{|e| load_snapshot(e.gsub(/#pdf/,s.gsub(/0/,'')), date)}.flatten.select{|e| e=~/\s200\s/}
    end
    def pdf05_log_raw(s=nil, date=nil)
      PDF_SEARCH.map{|e| load_snapshot(e.gsub(/#pdf/,s), date)}.flatten.select{|e| e=~/\s200\s/} +
      PDF_SEARCH.map{|e| load_snapshot(e.gsub(/#pdf/,s.gsub(/0/,'')), date)}.flatten.select{|e| e=~/\s200\s/}
    end
    def pdf06_log_raw(s=nil, date=nil)
      PDF_SEARCH.map{|e| load_snapshot(e.gsub(/#pdf/,s), date)}.flatten.select{|e| e=~/\s200\s/} +
      PDF_SEARCH.map{|e| load_snapshot(e.gsub(/#pdf/,s.gsub(/0/,'')), date)}.flatten.select{|e| e=~/\s200\s/}
    end
    def pdf07_log_raw(s=nil, date=nil)
      PDF_SEARCH.map{|e| load_snapshot(e.gsub(/#pdf/,s), date)}.flatten.select{|e| e=~/\s200\s/} +
      PDF_SEARCH.map{|e| load_snapshot(e.gsub(/#pdf/,s.gsub(/0/,'')), date)}.flatten.select{|e| e=~/\s200\s/}
    end

    def pdf01_log_arr(s, date); log_arr("pdf01", s, date) end
    def pdf02_log_arr(s, date); log_arr("pdf02", s, date) end
    def pdf03_log_arr(s, date); log_arr("pdf03", s, date) end
    def pdf04_log_arr(s, date); log_arr("pdf04", s, date) end
    def pdf05_log_arr(s, date); log_arr("pdf05", s, date) end
    def pdf06_log_arr(s, date); log_arr("pdf06", s, date) end
    def pdf07_log_arr(s, date); log_arr("pdf07", s, date) end

#    def pdf_logs; logs("pdf") end
#    def pdf_logs_raw; PDF_SEARCH.map{|e| load(e).select{|e| e=~/\s200\s/}}.flatten end
    def top_page_search; TOP_PAGE_SEARCH end
  end
end
