require File.dirname(__FILE__) + '/../spec_helper'

describe RiecnewsLog do
  describe "#pdf_log_raw" do
    before(:each) do
      s = '172.20.0.146 - - [28/Sep/2011:14:06:01 +0900] "GET /riecnews/main/riecnews_no01.pdf HTTP/1.1" 200 '
      s += "\n"
      s += '172.20.0.146 - - [28/Sep/2011:14:06:01 +0900] "GET /riecnews/main/riecnews_no02.pdf HTTP/1.1" 206 '
      RiecnewsLog.save(s)
    end

    it "collects the pdf with the right title" do
      RiecnewsLog.pdf01_log_raw("riecnews_no01").should eq ['172.20.0.146 - - [28/Sep/2011:14:06:01 +0900] "GET /riecnews/main/riecnews_no01.pdf HTTP/1.1" 200 ']
    end

    it "collects pdf with 200" do
      RiecnewsLog.pdf02_log_raw("riecnews_no02").should eq []
    end
  end

  describe "#top_page_logs_arr" do
    it "splits up in ip & date" do
      s = '172.20.0.146 - - [28/Sep/2011:14:06:01 +0900] "GET /riecnews HTTP/1.1" 304'
      RiecnewsLog.save(s)
      RiecnewsLog.top_page_log_arr.should eq [["172.20.0.146","28/Sep/2011:14:06:01 +0900"]]
    end

    it "splits up logs in arrays" do
      s = '172.20.0.146 - - [28/Sep/2011:14:06:01 +0900] "GET /riecnews HTTP/1.1" 304'
      s += "\n"
      s += '172.20.0.146 - - [20/Sep/2011:14:06:01 +0900] "GET /riecnews HTTP/1.1" 304'
      RiecnewsLog.save(s)
      RiecnewsLog.top_page_log_arr.should eq [["172.20.0.146","28/Sep/2011:14:06:01 +0900"],["172.20.0.146","20/Sep/2011:14:06:01 +0900"]]
    end
  end

  describe "#top_page_logs_raw" do 
    context "catches..." do
      it "index-j.shtml" do
        @s = '172.20.0.146 - - [28/Sep/2011:13:50:40 +0900] "GET /riecnews/index-j.shtml HTTP/1.1" 200'
      end

      it "." do
        @s = '172.20.0.146 - - [28/Sep/2011:14:06:01 +0900] "GET /riecnews HTTP/1.1" 304'
      end

      it "/" do
        @s = '172.20.0.146 - - [28/Sep/2011:14:19:14 +0900] "GET /riecnews/ HTTP/1.1" 304'
      end

      after(:each) do
        RiecnewsLog.save(@s)
        RiecnewsLog.top_page_log_raw.count.should eq 1
      end
    end
  end
end
