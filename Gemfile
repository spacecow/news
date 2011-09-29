source 'http://rubygems.org'

gem 'rails', '3.0.5'
gem 'mysql2', '<0.3'
gem 'formtastic' #rails g formtastic:install
gem 'compass', '0.11.beta.7' #compass init rails /path/to/myrailsproject --using blueprint/semantic
gem 'cancan' #rails g cancan:ability
gem "bcrypt-ruby", :require => "bcrypt"
gem "escape_utils"
#gem "mocha", :group => :test

group :development do
  gem 'nifty-generators', :path => "~/ruby/rails/nifty-generators"
  gem "rspec-rails" #rails g rspec:install
end

group :test do
  gem 'spork', '> 0.9.0.rc'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'cucumber-rails' #rails g cucumber:install --capybara --rspec
  gem 'capybara'
  gem 'database_cleaner'
  gem 'pickle' #rails g pickle --paths --email
  gem 'launchy'
  gem 'factory_girl'
  gem 'gherkin'
end
