class LogsController < ApplicationController
  def index
    case params[:commit]
    when "Generate"
      @log = RiecnewsLog.top_page_log
      @pdflog1 = RiecnewsLog.pdf_log("riecnews_no01")
      @pdflog2 = RiecnewsLog.pdf_log("riecnews_no02")
      Log.destroy_all
      @log.logs.each{|log| log.save} 
      @pdflog1.logs.each{|log| log.save} 
      @pdflog2.logs.each{|log| log.save} 
    else 
      @log = RiecnewsLog.new Log.where(:category => "top_page")
      @pdflog1 = RiecnewsLog.new Log.where(:category => "pdf01")
      @pdflog2 = RiecnewsLog.new Log.where(:category => "pdf02")
    end
  end
end
