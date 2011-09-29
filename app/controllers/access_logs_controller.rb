class AccessLogsController < ApplicationController
  def index
    @log = ApacheAccessLog.riecnews_root_logs
  end
end
