require File.dirname(__FILE__) + '/../spec_helper'

describe ApacheAccessLog do
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
end
