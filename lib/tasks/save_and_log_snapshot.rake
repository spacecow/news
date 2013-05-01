namespace :riec do
  desc "Save a map of symlinks"
  task :save_symlinks_map => :environment do
    Johan::File.save_symlinks_map
  end

  desc "Replace symlinks with their actual files"
  task :replace_symlinks => :environment do
    Johan::File.replace_symlinks
  end

  desc "Unlink symlinks and save to map file"
  task :pre_deploy => :environment do
    Johan::File.pre_deploy
  end

  desc "Link up symlinks again from map file"
  task :post_deploy => :environment do
    Johan::File.post_deploy
  end

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
