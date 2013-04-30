# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require 'capybara/rails'
require 'debugger'

require 'minitest/reporters'
MiniTest::Reporters.use! MiniTest::Reporters::SpecReporter.new

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir['#{File.dirname(__FILE__)}/support/**/*.rb'].each { |f| require f }

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  before(:each) do
    DatabaseCleaner.start
    create_users
  end

  after(:each) { DatabaseCleaner.clean }

  class << self
    alias context describe
  end
end

class FeatureTest < MiniTest::Spec
  include Rails.application.routes.url_helpers # to get url_helpers working
  include Capybara::DSL # to get capybara working

  before(:each) do
    create_users
  end
end


def create_users
  @sender       = User.where(email: 'teacher@school.com', first_name: 'teacher').first_or_create
  @recipient    = User.where(email: 'bart@student.com', first_name: 'bart', last_name: 'simpsons').first_or_create
  @lisa         = User.where(email: 'lisa@student.com', first_name: 'lisa', last_name: 'simpsons').first_or_create
end
