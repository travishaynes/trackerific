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

ENV['RAILS_ENV'] = 'test'

require 'rubygems'
require 'bundler/setup'
require 'trackerific'
require 'fakeweb'
require 'savon/mock/spec_helper'

# load all the support files
Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }
