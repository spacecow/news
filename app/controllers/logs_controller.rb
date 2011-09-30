class LogsController < ApplicationController
  def index
    case params[:commit]
    when "Generate"
      @log = RiecnewsLog.top_page_logs
      Log.destroy_all
      @log.logs.each{|log| log.save} 
    else 
      @log = RiecnewsLog.new Log.all
    end
  end
end
