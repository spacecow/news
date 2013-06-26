namespace :linker do
  desc "Save a map of symlinks"
  task :save_symlinks_map => :environment do
    Johan::Linker.save_symlinks_map
  end

  desc "Replace symlinks with their actual files"
  task :replace_symlinks => :environment do
    Johan::Linker.replace_symlinks
  end

  desc "Unlink symlinks and save to map file"
  task :pre_deploy => :environment do
    Johan::Linker.pre_deploy
  end

  desc "Link up symlinks again from map file"
  task :post_deploy => :environment do
    Johan::Linker.post_deploy
  end
end

namespace :riec do
  desc "Populate the riecnews access log from apache log"
  task :populate_access_log => :environment do
    Analyzer.populate_riecnews_access_log
  end

  desc "Create all logs from riecnews access log"
  task :create_logs => :environment do
    Analyzer.save_snapshot
  end

  desc "Create log by month (yymm) from riecnews access log"
  task :create_log_by_month, [:date] => :environment do |t, args|
    Analyzer.save_snapshot_by_month args.date
  end

  desc "Populate yesterdays log from apache log"
  task :populate_yesterday => :environment do |t, args|
    Analyzer.save_yesterdays_snapshot
  end

  desc "Show unique occurrences of pdf paths"
  task :unique_pdf_paths => :environment do
    print "\r\n#{Analyzer.unique_pdf_paths}\r\n"
  end
end
