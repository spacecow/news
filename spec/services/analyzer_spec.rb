require 'spec_helper'

describe Analyzer do
  let(:access_log){ 'data/access_log_test' }
  let(:riecnews_log){ 'data/riecnews_log_test' }
  let(:analyzer){ Analyzer.new }
  let(:mar11){ '172.20.0.146 - - [28/Mar/2011:14:06:01 +0900] "GET /riecnews/main/riecnews_no01.pdf HTTP/1.1" 200 ...'+"\n" }
  let(:mar112){ '172.20.0.145 - - [28/Mar/2011:14:06:01 +0900] "GET /riecnews/main/riecnews_no01.pdf HTTP/1.1" 200 ...'+"\n" }
  let(:may11){ '172.20.0.146 - - [28/May/2011:14:06:01 +0900] "GET /riecnews/main/riecnews_no02.pdf HTTP/1.1" 200 ...' }

  # ============== UNIQUE PDF PATHS ==============
  describe ".unique_pdf_paths" do
    before do
      Analyzer.should_receive(:riecnews_log_path).and_return riecnews_log
      File.open(riecnews_log, 'w') do |f| 
        f.write(mar11)
      end
    end

    it{ Analyzer.unique_pdf_paths.should eq "/riecnews/main/riecnews_no01.pdf"}

    after{ File.delete riecnews_log }
  end
  # == LOAD RIECNEWS ACCESS LOG ===============
  describe ".load_riecnews_access_log", load_file:true do
    before do
      Analyzer.should_receive(:riecnews_log_path).and_return riecnews_log 
      File.open(riecnews_log, 'w') do |f| 
        f.write(mar11)
        f.write(mar112)
        f.write(may11)
      end
    end

    it "loads the month provided" do
      Analyzer.load_riecnews_access_log("Mar/2011").should eq "#{mar11}#{mar112}"
    end

    it "loads the string day provided" do
      Analyzer.load_riecnews_access_log("28/May/2011").should eq "#{may11}\n"
    end

    it "loads the date provided" do
      Analyzer.load_riecnews_access_log(Date.parse("28/May/2011")).should eq "#{may11}\n"
    end

    after{ File.delete riecnews_log }
  end
  # == POPULATE RIECNEWS ACCESS LOG ======
  describe ".save_riecnews_access_log", save_file:true do
    let(:nonriec){ '172.20.0.146 - - [28/Mar/2011:14:06:01 +0900] "GET /fakenews/main/fakenews_no01.pdf HTTP/1.1" 200 ...'+"\n" }
    let(:non200){ '172.20.0.146 - - [28/Mar/2011:14:06:01 +0900] "GET /riecnews/main/riecnews_no01.pdf HTTP/1.1" 206 ...'+"\n" }
    before do
      Analyzer.should_receive(:access_log_path).and_return access_log
      File.open(access_log, 'w') do |f| 
        f.write(mar112+nonriec+non200)
      end
      Analyzer.should_receive(:riecnews_log_path).and_return riecnews_log
    end

    it "does not save nonriec news or non 200" do
      Analyzer.populate_riecnews_access_log
      begin
        File.open(riecnews_log, 'r') do |f|
          f.readlines.should eq [mar112]
        end
      ensure
        File.delete riecnews_log
        File.delete access_log
      end
    end
  end
  # == SAVE SNAPSHOT BY MONTH ============
  describe ".save_snapshot_by_month", save_file:true do
    let(:outfile){ "#{riecnews_log}_1103" }

    it "month has to be four numbers" do
      Analyzer.should_not_receive(:riecnews_log_path)
      lambda{ Analyzer.save_snapshot_by_month '110' }.should raise_error AssertionFailure
    end

    context "deletes and repopulates" do
      before do
        Analyzer.should_receive(:riecnews_log_path).and_return riecnews_log
        Analyzer.should_receive(:load_riecnews_access_log).with('Mar/2011').and_return mar11
        Analyzer.should_receive(:save_riecnews_access_log).with(mar11,outfile)
        #Analyzer.should_receive(:create_logs).with(mar11)
      end

      context "logs by month" do
        let(:month){ create :month, name:'1103' }
        let(:category){ create :category, month:month, name:'pdf02' }
        before do
          create :log, category:category
          Analyzer.save_snapshot_by_month '1103'
        end

        context Log do
          subject{ Log }
          its(:count){ should eq 1 }
        end

        context Category do
          subject{ Category }
          its(:count){ should eq 1 }
        end
      end

      context "not logs by different month" do
        let(:month){ create :month, name:'1104' }
        let(:category){ create :category, month:month }
        before do
          create :log, category:category
          Analyzer.save_snapshot_by_month '1103'
        end

        context Log do
          subject{ Log }
          its(:count){ should eq 2 }
        end

        context Category do
          subject{ Category }
          its(:count){ should eq 2 }
        end
      end
    end
  end
  # == SAVE RIECNEWS ACCESS LOG ======
  describe ".save_riecnews_access_log", save_file:true do
    let(:outfile){ "#{riecnews_log}_1103" }
    before{ Analyzer.save_riecnews_access_log mar11, outfile }
    it "saves the log to a file taged by that month" do
      begin
        File.open(outfile, 'r') do |f|
          f.readlines.should eq [mar11]
        end
      ensure
        File.delete outfile
      end
    end
  end
  # == CATEGORY ======================
  describe ".category" do
    it{ Analyzer.category("/riecnews/main/riecnews_no01.pdf").should eq 'pdf01' }
    it{ Analyzer.category("/riecnews/main/riecnews_no02.pdf").should eq 'pdf02' }
    it{ Analyzer.category("/riecnews/main/riecnews_02.pdf").should eq 'pdf02' }
    it{ Analyzer.category("/riecnews/main/riecnews_no2.pdf").should eq 'pdf02' }
    it{ Analyzer.category("/riecnews/index-j.shtml").should eq 'page_top' }
    it{ Analyzer.category("/riecnews").should eq 'page_top' }
    it{ Analyzer.category("/riecnews/").should eq 'page_top' }
  end
  # == CREATE LOGS ===================
  describe ".create_logs" do
    let(:create_log){ lambda{ Analyzer.create_logs mar11 }}
    let(:nonriec){ '172.20.0.146 - - [28/Mar/2011:14:06:01 +0900] "GET /fakenews/main/fakenews_no01.pdf HTTP/1.1" 200 ...'+"\n" }

    context "create log" do
      before{ create_log.call }
  
      context "last category" do
        subject{ Category.last }
        its(:log_count){ should be 1 }
        its(:unique_log_count){ should be 1 }
        its(:month_id){ should be Month.last.id }
      end

      context "last log" do
        subject{ Log.last }
        its(:category_id){ should be Category.last.id }
      end
    end

    context "hostname contains crawl," do
      crawl = '66.249.74.89 - - [28/Mar/2011:14:06:01 +0900] "GET /riecnews/main/riecnews_no01.pdf HTTP/1.1" 200 ...'+"\n"
      
      it "log is not created the first time" do
        expect{ Analyzer.create_logs crawl,{} }.to change(Log,:count).by(0)
      end
      it "hash in element is set to true" do
        hash = {}
        Analyzer.create_logs crawl,hash
        hash.should eq({'66.249.74.89'=>false})
      end
      it "log is not created the second time" do
        hash = {}
        Analyzer.create_logs crawl,hash
        expect{ Analyzer.create_logs crawl,hash }.to change(Log,:count).by(0)
      end
    end

    context "name does not exits" do
      noname = '172.20.24.3 - - [28/Mar/2011:14:06:01 +0900] "GET /riecnews/main/riecnews_no01.pdf HTTP/1.1" 200 ...'+"\n"

      it "log is created the first time" do
        expect{ Analyzer.create_logs noname,{} }.to change(Log,:count).by(1)
      end
      it "hash in element is initialized to 1" do
        hash = {}
        Analyzer.create_logs noname,hash
        hash.should eq({'172.20.24.3'=>1})
      end
      it "log is created the second time" do
        hash = {}
        Analyzer.create_logs noname,hash
        expect{ Analyzer.create_logs noname,hash }.to change(Log,:count).by(1)
      end
      it "hash in element is increased the second time" do
        hash = {}
        Analyzer.create_logs noname,hash
        Analyzer.create_logs noname,hash
        hash.should eq({'172.20.24.3'=>2})
      end
    end

    context "name does exits" do
      hash = {}
      noname = '180.16.97.111 - - [28/Mar/2011:14:06:01 +0900] "GET /riecnews/main/riecnews_no01.pdf HTTP/1.1" 200 ...'+"\n"

      it "log is created" do
        expect{ Analyzer.create_logs noname,hash }.to change(Log,:count).by(1)
      end
      it "hash in element is set to true" do
        hash.should eq({'180.16.97.111'=>1})
      end
    end
    context "create log where ip is already taken" do
      let(:month){ create :month, name:'1103' }
      let(:category){ create :category, name:'pdf01', month:month }
      before do
        category.logs << build(:log, ip:'172.20.0.146')
        create_log.call
      end

      context "last category" do
        subject{ Category.last }
        its(:log_count){ should be 2 }
        its(:unique_log_count){ should be 1 }
      end
    end

    context "category does not exist" do
      it{ create_log.should change(Category, :count).by 1 }
      it{ create_log.should change(Month, :count).by 1 }
    end

    context "category does already exist for the same month" do
      before do
        month = create :month, name:'1103' 
        create :category, name:'pdf01', month:month
      end
      it{ create_log.should change(Category, :count).by 0 }
      it{ create_log.should change(Month, :count).by 0 }
    end
    
    context "category exists for a different month" do
      before do
        month = create :month, name:'1104' 
        create :category, name:'pdf01', month:month
      end
      it{ create_log.should change(Category, :count).by 1 }
      it{ create_log.should change(Month, :count).by 1 }
    end

    it "only riecnews pdfs and top pages are logged" do
      Analyzer.create_logs nonriec
      Log.count.should be 0
    end

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
      before{ Analyzer.create_logs mar11+mar112 }

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
  # == SAVE SNAPSHOT =================
  describe ".save_snapshot", save_file:true do
    before do
      Analyzer.should_receive(:month_intervals).and_return [Date.parse('2011-03-01')]
      Analyzer.should_receive(:save_snapshot_by_month).with('1103', {})
      Analyzer.save_snapshot
    end
    it "should work" do end
  end
  # == SAVE YESTERDAYS SNAPSHOT ============
  describe ".save_yesterdays_snapshot" do
    let(:outfile){ "#{riecnews_log}_110528" }
    before do
      Analyzer.should_receive(:yesterday).and_return Date.parse '2011-05-28'
      Analyzer.should_receive(:load_access_log).with("28/May/2011").and_return may11
      Analyzer.should_receive(:riecnews_log_path).and_return riecnews_log
      Analyzer.should_receive(:save_riecnews_access_log).with(may11, outfile)
      Analyzer.save_yesterdays_snapshot
    end

    context Log do  
      subject{ Log }
      its(:count){ should be 1 }
    end
  end
  # == MONTH INTERVALS ===============
  describe ".month_intervals" do
    before{ Analyzer.should_receive(:beginning_of_this_month).and_return Date.parse('2011-05-01') }
    it{ Analyzer.month_intervals.should eq [Date.parse('2011-03-01'), Date.parse('2011-04-01'), Date.parse('2011-05-01')] }
  end

  #describe "#add_log" do
  #  context "assertion failure" do
  #    it "must include riecnews" do
  #      lambda{ analyzer.add_log("66.249.68.74 - - [28/Sep/2011:00:12:42 +0900] 200 ")
  #      }.should raise_error AssertionFailure
  #    end

  #    it "must have success code 200" do
  #      lambda{ analyzer.add_log("66.249.68.74 - - [28/Sep/2011:00:12:42 +0900] riecnews")
  #      }.should raise_error AssertionFailure
  #    end
  #  end

  #  before{ analyzer.add_log("66.249.68.74 - - [28/Sep/2011:00:12:42 +0900] riecnews 200 ") }

  #  context Log do
  #    subject{ Log }
  #    its(:count){ should eq 1 }
  #  end

  #  context "last log" do
  #    subject{ Log.last }
  #    its(:ip){ should eq '66.249.68.74' }
  #    its(:date){ should eq Time.zone.parse('2011-09-28') }
  #  end
  #end
end
