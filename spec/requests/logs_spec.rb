require 'spec_helper'

describe "Logs" do
  describe "GET /logs" do
    context "displays statistics for database:" do
      it "0" do
        visit logs_path
        page.should have_content("Total hits: 0")
      end

      it "1" do
        Log.create(:ip => '135.20.0.146', :date => Date.parse('20/Aug/2011:14:06:01 +0900'))
        visit logs_path
        page.should have_content("Total hits: 1")
      end
    end

    context "displays statistics for access log" do
      before(:each) do
        ApacheAccessLog.save('172.20.0.146 - - [28/Sep/2011:13:50:40 +0900] "GET /riecnews HTTP/1.1" 200')
        visit logs_path
      end

      it "does not change if not asked so" do
        page.should have_content("Total hits: 0")
      end

      it "creates them from logs if asked so" do
        click_button("Generate")
        page.should have_content("Total hits: 1")
      end

      it "generated logs stays saved" do
        click_button("Generate")
        visit logs_path
        page.should have_content("Total hits: 1")
      end

      it "generated logs clears out saved logs" do
        Log.create(:ip => '135.20.0.146', :date => Date.parse('20/Aug/2011:14:06:01 +0900'))
        click_button("Generate")
        page.should have_content("Total hits: 1")
        Log.count.should be(1)
      end
    end
  end
end
