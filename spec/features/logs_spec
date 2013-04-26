require 'spec_helper'

describe "Logs" do
  describe "GET /logs" do
    context "displays statistics from database:" do
      it "0 top page hits" do
        visit logs_path
        page.should have_content("Top page hits: 0(0)")
      end

      it "1 top page hit" do
        Log.create(:ip => '135.20.0.146', :date => Date.parse('20/Aug/2011:14:06:01 +0900'), :category => "top_page")
        visit logs_path
        page.should have_content("Top page hits: 1(1)")
        page.should have_content("Pdf1 downloads: 0(0)")
        page.should have_content("Pdf2 downloads: 0(0)")
      end

      it "1 pdf1 download" do
        Log.create(:ip => '135.20.0.146', :date => Date.parse('20/Aug/2011:14:06:01 +0900'), :category => "pdf01")
        visit logs_path
        page.should have_content("Top page hits: 0(0)")
        page.should have_content("Pdf1 downloads: 1(1)")
        page.should have_content("Pdf2 downloads: 0(0)")
      end

      it "1 pdf2 download" do
        Log.create(:ip => '135.20.0.146', :date => Date.parse('20/Aug/2011:14:06:01 +0900'), :category => "pdf02")
        visit logs_path
        page.should have_content("Top page hits: 0(0)")
        page.should have_content("Pdf1 downloads: 0(0)")
        page.should have_content("Pdf2 downloads: 1(1)")
      end
    end

    context "displays statistics from access log" do
      before(:each) do
        s = '172.20.0.146 - - [28/Sep/2011:13:50:40 +0900] "GET /riecnews HTTP/1.1" 200'
        s += "\n"
        s += '172.20.0.146 - - [28/Sep/2011:13:50:40 +0900] "GET /riecnews/main/riecnews_no01.pdf HTTP/1.1" 200 '
        s += "\n"
        s += '172.20.0.146 - - [28/Sep/2011:13:50:40 +0900] "GET /riecnews/main/riecnews_no02.pdf HTTP/1.1" 200 '
        LogAnalyzer.should_receive(:load_access_log).and_return s 
        ApacheAccessLog.save_snapshot
        visit logs_path
      end

      it "does not change if not asked so" do
        page.should have_content("Top page hits: 0(0)")
        page.should have_content("Pdf1 downloads: 0(0)")
        page.should have_content("Pdf2 downloads: 0(0)")
      end

      it "creates them from logs if asked so" do
        click_button("Generate")
        page.should have_content("Top page hits: 1(1)")
        page.should have_content("Pdf1 downloads: 1(1)")
        page.should have_content("Pdf2 downloads: 1(1)")
      end

      it "generated logs stays saved" do
        click_button("Generate")
        visit logs_path
        page.should have_content("Top page hits: 1(1)")
        page.should have_content("Pdf1 downloads: 1(1)")
        page.should have_content("Pdf2 downloads: 1(1)")
      end

      it "generated logs clears out saved logs" do
        Log.create(:ip => '135.20.0.146', :date => Date.parse('20/Aug/2011:14:06:01 +0900'), :category => "top_page")
        click_button("Generate")
        page.should have_content("Top page hits: 1(1)")
        page.should have_content("Pdf1 downloads: 1(1)")
        page.should have_content("Pdf2 downloads: 1(1)")
        Log.count.should be(3)
      end
    end
  end
end
