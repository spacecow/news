class LogsController < ApplicationController
  def index
    case params[:commit]
    when "Generate"
      @log = RiecnewsLog.top_page_log
      @pdflog1 = RiecnewsLog.pdf_log("riecnews_no01")
      @pdflog2 = RiecnewsLog.pdf_log("riecnews_no02")
      @pdflog3 = RiecnewsLog.pdf_log("riecnews_no03")
      @pdflog4 = RiecnewsLog.pdf_log("riecnews_no04")
      @pdflog5 = RiecnewsLog.pdf_log("riecnews_no05")
      @pdflog6 = RiecnewsLog.pdf_log("riecnews_no06")
      Log.destroy_all
      @log.logs.each{|log| log.save} 
      @pdflog1.logs.each{|log| log.save} 
      @pdflog2.logs.each{|log| log.save} 
      @pdflog3.logs.each{|log| log.save} 
      @pdflog4.logs.each{|log| log.save} 
      @pdflog5.logs.each{|log| log.save} 
      @pdflog6.logs.each{|log| log.save} 
    else 
      @log = RiecnewsLog.new [Log.where(:category => "top_page").first]
      @pdflog1 = RiecnewsLog.new Log.where(:category => "pdf01")
      @pdflog2 = RiecnewsLog.new Log.where(:category => "pdf02")
      @pdflog3 = RiecnewsLog.new Log.where(:category => "pdf03")
      @pdflog4 = RiecnewsLog.new Log.where(:category => "pdf04")
      @pdflog5 = RiecnewsLog.new Log.where(:category => "pdf05")
      @pdflog6 = RiecnewsLog.new Log.where(:category => "pdf06")
    end
  end
end
