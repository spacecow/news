namespace :riec do
  desc "Populate the riecnews access log"
  task :populate_access_log => :environment do
    Analyzer.populate_riecnews_access_log
  end

  desc "Create all logs"
  task :create_logs => :environment do
    Analyzer.save_snapshot
  end

  desc "Create log by month (yymm)"
  task :create_log_by_month, [:date] => :environment do |t, args|
    Analyzer.save_snapshot_by_month args.date
  end

  desc "Create yesterdays log"
  task :create_yesterdays => :environment do |t, args|
    Analyzer.save_yesterdays_snapshot args.date
  end

  desc "Show unique occurrences of pdf paths"
  task :unique_pdf_paths => :environment do
    print "\r\n#{Analyzer.unique_pdf_paths}\r\n"
  end
end
