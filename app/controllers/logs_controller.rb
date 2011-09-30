class LogsController < ApplicationController
  def index
    case params[:commit]
    when "Generate"
      @log = ApacheAccessLog.riecnews_root_logs
      Log.destroy_all
      @log.logs.each{|log| log.save} 
    else 
      @log = ApacheAccessLog.new Log.all
    end
  end
end
