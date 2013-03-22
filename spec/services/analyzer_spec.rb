require 'spec_helper'

describe Analyzer, focus:true do
  let(:analyzer){ Analyzer.new }
  let(:mar11){ '172.20.0.146 - - [28/Mar/2011:14:06:01 +0900] "GET /riecnews/main/riecnews_no01.pdf HTTP/1.1" 200 ...' }
  let(:mar112){ '172.20.0.145 - - [28/Mar/2011:14:06:01 +0900] "GET /riecnews/main/riecnews_no01.pdf HTTP/1.1" 200 ...' }

  # ============== LOAD ACCESS LOG ===============
  describe ".load_access_log", load_file:true do
    let(:may11){ '172.20.0.146 - - [28/May/2011:14:06:01 +0900] "GET /riecnews/main/riecnews_no02.pdf HTTP/1.1" 200 ...' }
    let(:test_file){ 'access_log_test' }
    before do
      Analyzer.should_receive(:path).and_return "/usr/local/apache2/logs/www/#{test_file}"
      File.open("/usr/local/apache2/logs/www/#{test_file}","w") do |f| 
        f.write("#{mar11}\n")
        f.write("#{mar112}\n")
        f.write("#{may11}\n")
      end
    end

    it "loads the month provided" do
      Analyzer.load_access_log("Mar/2011").should eq "#{mar11}\n#{mar112}"
    end

    it "loads the string day provided" do
      Analyzer.load_access_log("28/May/2011").should eq may11
    end

    it "loads the date provided" do
      Analyzer.load_access_log(Date.parse("28/May/2011")).should eq may11
    end
  end
  # ============ SAVE ACCESS LOG ===============
  describe ".save_access_log" do
    it "provided month must contain 4 numbers" do
      lambda{ Analyzer.save_access_log 'wasap', 'Mar/2011' }.should raise_error AssertionFailure
    end

    it "", save_file:true do
      Analyzer.save_access_log "#{mar11}\n#{mar112}", "1103"
      File.open("data/riecnews_access_log_1103","r") do |f|
        f.readlines.should eq [mar11+"\n", mar112]
      end
    end
  end
  # ============ CREATE LOGS ===================
  describe ".create_logs" do
    context "one line" do
      before{ Analyzer.create_logs mar11 }

      context Log do
        subject{ Log }
        its(:count){ should be 1 }
      end

      context "first log" do
        subject{ Log.last }
        its(:ip){ should eq '172.20.0.146' }
        its(:date){ should eq Time.zone.parse('2011-03-28') }
      end
    end

    context "multiple lines" do
      before{ Analyzer.create_logs "#{mar11}\n#{mar112}" }

      context Log do
        subject{ Log }
        its(:count){ should be 2 }
      end

      context "first log" do
        subject{ Log.first }
        its(:ip){ should eq '172.20.0.146' }
        its(:date){ should eq Time.zone.parse('2011-03-28') }
      end

      context "last log" do
        subject{ Log.last }
        its(:ip){ should eq '172.20.0.145' }
        its(:date){ should eq Time.zone.parse('2011-03-28') }
      end
    end
  end
  # ============ SAVE SNAPSHOT =================
  describe ".save_snapshot", save_file:true do
    before do
      Analyzer.should_receive(:month_intervals).and_return [Date.parse('2011-03-01')]
      Analyzer.should_receive(:load_access_log).and_return mar11 
      Analyzer.save_snapshot
    end

    it do
      File.open("data/riecnews_access_log_1103","r") do |f|
        f.readlines.should eq [mar11]
      end
    end
  end
  # ============== MONTH INTERVALS ===============
  describe ".month_intervals" do
    before{ Analyzer.should_receive(:beginning_of_this_month).and_return Date.parse('2011-05-01') }
    it{ Analyzer.month_intervals.should eq [Date.parse('2011-03-01'), Date.parse('2011-04-01'), Date.parse('2011-05-01')] }
  end

  describe "#add_log" do
    context "assertion failure" do
      it "must include riecnews" do
        lambda{ analyzer.add_log("66.249.68.74 - - [28/Sep/2011:00:12:42 +0900] 200 ")
        }.should raise_error AssertionFailure
      end

      it "must have success code 200" do
        lambda{ analyzer.add_log("66.249.68.74 - - [28/Sep/2011:00:12:42 +0900] riecnews")
        }.should raise_error AssertionFailure
      end
    end

    before{ analyzer.add_log("66.249.68.74 - - [28/Sep/2011:00:12:42 +0900] riecnews 200 ") }

    context Log do
      subject{ Log }
      its(:count){ should eq 1 }
    end

    context "last log" do
      subject{ Log.last }
      its(:ip){ should eq '66.249.68.74' }
      its(:date){ should eq Time.zone.parse('2011-09-28') }
    end
  end
end
