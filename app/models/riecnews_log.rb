class RiecnewsLog < ApacheAccessLog
  PDF_SEARCH = ["GET /riecnews/main/#pdf.pdf HTTP", "GET /archive/publication/riecnewspdf/#pdf.pdf HTTP"]
  TOP_PAGE_SEARCH = ["GET /riecnews/index-j.shtml HTTP","GET /riecnews HTTP","GET /riecnews/ HTTP"]

  class << self
    def pdf_log(s=nil)
      data = s.match(/(\d+)/)
      log("pdf#{data[1]}",s)
    end
    def pdf01_log_raw(s=nil)
      PDF_SEARCH.map{|e| load(e.gsub(/#pdf/,s))}.flatten.select{|e| e=~/\s200\s/} +
      PDF_SEARCH.map{|e| load(e.gsub(/#pdf/,s.gsub(/0/,'')))}.flatten.select{|e| e=~/\s200\s/}
    end
    def pdf02_log_raw(s=nil)
      PDF_SEARCH.map{|e| load(e.gsub(/#pdf/,s))}.flatten.select{|e| e=~/\s200\s/} +
      PDF_SEARCH.map{|e| load(e.gsub(/#pdf/,s.gsub(/0/,'')))}.flatten.select{|e| e=~/\s200\s/}
    end
    def pdf03_log_raw(s=nil)
      PDF_SEARCH.map{|e| load(e.gsub(/#pdf/,s))}.flatten.select{|e| e=~/\s200\s/} +
      PDF_SEARCH.map{|e| load(e.gsub(/#pdf/,s.gsub(/0/,'')))}.flatten.select{|e| e=~/\s200\s/}
    end
    def pdf04_log_raw(s=nil)
      PDF_SEARCH.map{|e| load(e.gsub(/#pdf/,s))}.flatten.select{|e| e=~/\s200\s/} +
      PDF_SEARCH.map{|e| load(e.gsub(/#pdf/,s.gsub(/0/,'')))}.flatten.select{|e| e=~/\s200\s/}
    end
    def pdf05_log_raw(s=nil)
      PDF_SEARCH.map{|e| load(e.gsub(/#pdf/,s))}.flatten.select{|e| e=~/\s200\s/} +
      PDF_SEARCH.map{|e| load(e.gsub(/#pdf/,s.gsub(/0/,'')))}.flatten.select{|e| e=~/\s200\s/}
    end
    def pdf06_log_raw(s=nil)
      PDF_SEARCH.map{|e| load(e.gsub(/#pdf/,s))}.flatten.select{|e| e=~/\s200\s/} +
      PDF_SEARCH.map{|e| load(e.gsub(/#pdf/,s.gsub(/0/,'')))}.flatten.select{|e| e=~/\s200\s/}
    end
    def pdf01_log_arr(s=nil); log_arr("pdf01",s) end
    def pdf02_log_arr(s=nil); log_arr("pdf02",s) end
    def pdf03_log_arr(s=nil); log_arr("pdf03",s) end
    def pdf04_log_arr(s=nil); log_arr("pdf04",s) end
    def pdf05_log_arr(s=nil); log_arr("pdf05",s) end
    def pdf06_log_arr(s=nil); log_arr("pdf06",s) end

#    def pdf_logs; logs("pdf") end
#    def pdf_logs_raw; PDF_SEARCH.map{|e| load(e).select{|e| e=~/\s200\s/}}.flatten end
    def top_page_search; TOP_PAGE_SEARCH end
  end
end
