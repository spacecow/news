task :save_and_log_snapshot => :environment do
  RiecnewsLog.save_and_log_snapshot
end
