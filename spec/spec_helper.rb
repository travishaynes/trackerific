require 'simplecov'

if ENV['CI']
  require 'coveralls'
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end

SimpleCov.start do
  add_group 'Parsers', 'lib/trackerific/parsers'
  add_group 'Builders', 'lib/trackerific/builders'
  add_group 'Services', 'lib/trackerific/services'
  add_filter 'spec'
end

ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler/setup'
require 'trackerific'
require 'fakeweb'
require 'savon/mock/spec_helper'
require 'active_support/core_ext/hash/conversions'

# load all the support files
Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
