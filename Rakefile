require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "trackerific"
  gem.homepage = "http://github.com/travishaynes/trackerific"
  gem.license = "MIT"
  gem.summary = %Q{Trackerific provides package tracking to Rails.}
  gem.description = %Q{Trackerific provides USPS, FedEx and UPS package tracking to Rails.}
  gem.email = "travis.j.haynes@gmail.com"
  gem.authors = ["Travis Haynes"]
  gem.add_dependency 'builder', "~> 2.1.2"
  gem.add_dependency 'xml-simple', "~> 1.0.15"
  gem.add_dependency 'savon', "~> 0.8.6"
  gem.add_dependency 'curb', "~> 0.7.15"
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new
