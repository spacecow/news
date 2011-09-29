require File.dirname(__FILE__) + '/../spec_helper'

describe ApacheAccessLog do
  describe "#riecnews_root" do
    before(:each) do
      s = '172.20.0.146 - - [28/Sep/2011:13:50:40 +0900] "GET /riecnews HTTP/1.1" 200'
      s += "\n"
      s += '172.20.0.146 - - [28/Sep/2011:13:50:40 +0900] "GET /riecnews HTTP/1.1" 200'
      s += "\n"
      s += '172.20.0.146 - - [28/Aug/2011:14:06:01 +0900] "GET /riecnews HTTP/1.1" 200'
      s += "\n"
      s += '135.20.0.146 - - [20/Aug/2011:14:06:01 +0900] "GET /riecnews HTTP/1.1" 200'
      ApacheAccessLog.save(s)
      @logs = ApacheAccessLog.riecnews_root_logs
    end

    it "total_hits, counts all" do
      @logs.total_hits.should eq 4
    end

    it "unique_hits, counts unique ips" do
      @logs.unique_hits.should eq 2
    end

    it "monthly_total_hits, counts all divied into arrayed monthes" do
      @logs.monthly_total_hits_arr.should eq [2,2]
    end

    it "monthly_unique_hits, counts unique hits divied into arrayed monthes" do
      @logs.monthly_unique_hits_arr.should eq [2,1]
    end

    it "monthly_total_hits(i), counts all divied within a month" do
      @logs.monthly_total_hits("08").should eq 2
    end

    it "monthly_unique_hits(i), counts unique hits within a month" do
      @logs.monthly_unique_hits("09").should eq 1
    end
  end

  describe "#load" do
    it "will return one line" do
      ApacheAccessLog.save("one line")
      ApacheAccessLog.load.should eq ["one line"]
    end

    it "will return two lines" do
      ApacheAccessLog.save("two\nlines")
      ApacheAccessLog.load.should eq %w(two lines) 
    end

    it "will read grepped lines" do
      ApacheAccessLog.save("three\nother lines\nend")
      ApacheAccessLog.load("other").should eq ["other lines"] 
    end
  end

  describe "#riecnews_root_logs" do
    it "parses into a log object" do
      s = '172.20.0.146 - - [28/Sep/2011:14:06:01 +0900] "GET /riecnews HTTP/1.1" 304'
      ApacheAccessLog.save(s)
      log = ApacheAccessLog.riecnews_root_logs.logs.first
      log.ip.should eq '172.20.0.146'
      log.date.should eq Date.parse('2011-9-28') 
    end
  end

  describe "#riecnews_root_logs_arr" do
    it "splits up in ip & date" do
      s = '172.20.0.146 - - [28/Sep/2011:14:06:01 +0900] "GET /riecnews HTTP/1.1" 304'
      ApacheAccessLog.save(s)
      ApacheAccessLog.riecnews_root_logs_arr.should eq [["172.20.0.146","28/Sep/2011:14:06:01 +0900"]]
    end

    it "splits up logs in arrays" do
      s = '172.20.0.146 - - [28/Sep/2011:14:06:01 +0900] "GET /riecnews HTTP/1.1" 304'
      s += "\n"
      s += '172.20.0.146 - - [20/Sep/2011:14:06:01 +0900] "GET /riecnews HTTP/1.1" 304'
      ApacheAccessLog.save(s)
      ApacheAccessLog.riecnews_root_logs_arr.should eq [["172.20.0.146","28/Sep/2011:14:06:01 +0900"],["172.20.0.146","20/Sep/2011:14:06:01 +0900"]]
    end
  end

  describe "#riecnews_root_logs_raw" do 
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
        ApacheAccessLog.save(@s)
        ApacheAccessLog.riecnews_root_logs_raw.count.should eq 1
      end
    end
  end
end
