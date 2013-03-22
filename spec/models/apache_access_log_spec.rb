require File.dirname(__FILE__) + '/../spec_helper'

describe ApacheAccessLog do
  describe "#save_snapshot", focus:true do
    it "greps all logs from the access_log" do
      Date.should_receive(:today).exactly(4).times.and_return Date.parse('2013-03-17')
      ApacheAccessLog.save_snapshot
      ApacheAccessLog.load_snapshot(nil).length.should be 4
    end

    it "greps the log by the provided string date from the access_log" do
      ApacheAccessLog.save_snapshot('110928')
      ApacheAccessLog.load_snapshot(nil,'110928').length.should be 3 
    end

    it "greps the log by the provided Date from the access_log" do
      ApacheAccessLog.save_snapshot(Date.parse('2011-09-28'))
      ApacheAccessLog.load_snapshot(nil,'110928').length.should be 3 
    end

    it "greps only riecnews related lines from the access_log" do
      ApacheAccessLog.save_snapshot('130318')
      ApacheAccessLog.load_snapshot(nil,'130318').length.should be 1 
    end
  end

  describe "#load_snapshot" do
    it "will return one line" do
      LogAnalyzer.should_receive(:load_access_log).and_return "one line"
      ApacheAccessLog.save_snapshot
      ApacheAccessLog.load_snapshot(nil).should eq ["one line"]
    end

    it "will return two lines" do
      LogAnalyzer.should_receive(:load_access_log).and_return "two\nlines"
      ApacheAccessLog.save_snapshot
      ApacheAccessLog.load_snapshot(nil).should eq %w(two lines) 
    end

    it "will read grepped lines" do
      LogAnalyzer.should_receive(:load_access_log).and_return "three\nother lines\nend"
      ApacheAccessLog.save_snapshot
      ApacheAccessLog.load_snapshot("other").should eq ["other lines"] 
    end
  end

  describe "#top_page_log" do
    it "" do
      pending
      # RiecnewsLog.top_page_log
    end
  end
end
