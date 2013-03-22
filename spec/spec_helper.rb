require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random"
    I18n.default_locale = :en

    # --------- Focus tag ------------------
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true
    # -- Shorten factory girl syntax -------
    config.include FactoryGirl::Syntax::Methods
    # --------- Testing presenters ---------
    config.include ActionView::TestCase::Behavior, example_group: {file_path: %r{spec/presenters}}
  end
end

Spork.each_run do
  FactoryGirl.reload
end

