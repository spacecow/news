require 'spec_helper'

describe Johan::Date do
  describe ".intervall" do
    context "2 days between first and last" do
      arr = [Time.zone.parse('Thu, 10 Jan 2013 11:42:59 JST +09:00'), Time.zone.parse('Thu, 10 Jan 2013 11:43:39 JST +09:00'), Time.zone.parse('Thu, 12 Jan 2013 15:59:52 JST +09:00')]
      subject{ Johan::Date.interval arr }
      it{ should eq [Date.parse('Thu, 10 Jan 2013'), Date.parse('Fri, 11 Jan 2013'), Date.parse('Sat, 12 Jan 2013')] }
    end
  end

  describe ".tag" do
    it "tags with todays date by default" do
      Date.should_receive(:today).once.and_return Date.parse('2013-03-18')
      Johan::Date.tag('string').should eq 'string_130318'
    end

    it "tags with the applied string" do
      Johan::Date.tag('string','130317').should eq 'string_130317'
    end

    it "tags with the applied date" do
      Johan::Date.tag('string',Date.parse('13-03-17')).should eq 'string_130317'
    end
  end
end
