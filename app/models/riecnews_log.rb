class RiecnewsLog < ApacheAccessLog
  PDF_SEARCH = ["GET /riecnews/main/riecnews_no01.pdf HTTP","GET /riecnews/main/riecnews_no02.pdf HTTP"]
  TOP_PAGE_SEARCH = ["GET /riecnews/index-j.shtml HTTP","GET /riecnews HTTP","GET /riecnews/ HTTP"]

  class << self

    def pdf_logs; logs("pdf") end
    def pdf_logs_arr; logs_arr("pdf") end
    def pdf_logs_raw; PDF_SEARCH.map{|e| load(e)}.flatten end
    def top_page_logs_raw; top_page_search.map{|e| load(e)}.flatten end
    def top_page_search; TOP_PAGE_SEARCH end
  end
end
