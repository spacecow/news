source 'http://rubygems.org'

gem 'annotate'
gem 'rails', '3.2.13'
gem 'mysql2'
gem 'cancan' #rails g cancan:ability
gem "bcrypt-ruby", :require => "bcrypt"
gem "escape_utils"
gem 'negative-captcha', :git => 'https://github.com/stefants/negative-captcha.git' #:path => '/home/staff/jsveholm/apps/negative-captcha'
gem 'pry'
gem 'jquery-rails'
gem 'simple_form'
gem 'unicorn'

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails'
end

group :development do
  gem "rspec-rails" #rails g rspec:install
  gem 'guard-spork'
end

group :test do
  gem 'rb-inotify', '~> 0.9'
  gem 'spork-rails'
  gem 'guard'
  gem 'guard-rspec'
  gem 'capybara'
  gem 'launchy'
  gem 'factory_girl_rails'
end
