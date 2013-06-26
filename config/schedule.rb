set :output, "#{path}/log/cron.log"

every 1.day, :at => '2:00am' do
  rake "riec:populate_yesterday"
end
