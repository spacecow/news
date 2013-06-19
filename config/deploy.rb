require "bundler/capistrano"

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

server "jasper.dmz.riec.tohoku.ac.jp", :web, :app, :db, primary:true

set :application, "riecnews"
set :user, "firdep"
set :deploy_to, "/home.local/firdep/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository,  "git@github.com:spacecow/news.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

#set :admin_runner, "firdep"
#set :git, "/opt/csw/bin/git"
#set :rake, "~/.rvm/rubies/ruby-1.9.2-head/bin/rake"
#set :default_environment, { 
#  'PATH' => "/opt/local/csw/bin:/opt/local/bin:/opt/csw/bin:/usr/bin:/usr/local/bin"
#  'RUBY_VERSION' => 'ruby 1.9.2',
#  'GEM_HOME' => '/home/aurora/.rvm/gems/ruby-1.9.2-head',
#  'GEM_PATH' => '/home/aurora/.rvm/gems/ruby-1.9.2-head' 
#}


# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    #sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    #sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    #put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"


  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/main #{release_path}/public/main" 
    run "ln -nfs #{shared_path}/main/index.html #{release_path}/app/views/layouts/application.html.erb"
    run "ln -nfs #{shared_path}/main/img #{release_path}/public/img"
  end
  after "deploy:finalize_update", "deploy:symlink_config"


  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end
