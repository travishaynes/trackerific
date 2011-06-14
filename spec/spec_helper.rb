require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler/setup'
require 'trackerific'
require 'rspec_multi_matchers'

# load all the support files
Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }
require 'rspec/rails' # this has to be loaded after the support files

RSpec.configure do |config|
  config.mock_with :rspec
end
