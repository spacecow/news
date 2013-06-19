# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
#ENV['RAILS_RELATIVE_URL_ROOT'] = '/riecnews'
#run Rack::URLMap.new(
#  ENV['RAILS_RELATIVE_URL_ROOT'] => Rails.application
#)
run Riecnews::Application
