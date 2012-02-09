require File.dirname(__FILE__) + '/../spec_helper'

describe ApacheAccessLog do
  describe "#load_date", focus:true do
    it "parses an apache log string" do
      Log.load_date('28/Sep/2011:14:19:14 +0900').should eq Date.parse('2011-9-28')
    end
    
    context "gives the month from the log..." do
      before(:each) do
        @log = Log.new(:ip => '135.20.0.146', :date => Date.parse('20/Aug/2011:14:06:01 +0900'))
      end
      
      it "abbrivated" do
        @log.month_abbr.should eq "Aug"
      end

      it "month no" do
        @log.month_no.should eq "08"
      end
    end
  end
end

# == Schema Information
#
# Table name: logs
#
#  id   :integer(4)      not null, primary key
#  ip   :string(255)
#  date :datetime
#

