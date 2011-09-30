require 'spec_helper'

describe LogAnalyzer do
  describe "hits" do
    before(:each) do
      logs = [create_log(0,'Sep'), create_log(0,'Sep'), create_log(0,'Aug'), create_log(1,'Aug')]
      @log = LogAnalyzer.new logs 
    end

    it "counts total hits" do
      @log.total_hits.should be(4)
    end

    it "counts unique hits" do
      @log.unique_hits.should be(2)
    end

    it "counts monthly total hits" do
      @log.monthly_total_hits_arr.should eq [2,2]
    end

    it "counts monthly unique hits" do
      @log.monthly_unique_hits_arr.should eq [2,1]
    end

    it "counts total hits for one month" do
      @log.monthly_total_hits("08").should be(2)
    end

    it "counts unique hits for one month" do
      @log.monthly_unique_hits("09").should be(1)
    end
  end
end

def create_log(no=0,month='Sep')
  Log.create(:ip => "135.20.0.#{no}", :date => Date.parse("20/#{month}/2011:14:06:01 +0900"))
end
