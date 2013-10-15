require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Starts an IRB console with Trackerific loaded'
task :console do
  require 'irb'
  require 'trackerific'
  ARGV.clear
  IRB.start
end
