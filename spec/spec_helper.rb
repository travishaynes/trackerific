ENV['RAILS_ENV'] = 'test'

require 'rubygems'
require 'bundler/setup'
require 'trackerific'
require 'fakeweb'
require 'savon/mock/spec_helper'

# load all the support files
Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }
