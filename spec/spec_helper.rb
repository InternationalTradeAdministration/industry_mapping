require 'simplecov'
SimpleCov.start 'rails'
SimpleCov.add_filter 'app/admin'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.order = 'random'
  config.include FactoryGirl::Syntax::Methods
end
