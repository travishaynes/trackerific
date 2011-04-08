require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'trackerific'
require 'trackerific_test_app'

class Test::Unit::TestCase
  def load_fixture(fixture_name)
    file_name = case fixture_name
      when :ups_success then File.join(File.dirname(__FILE__), 'fixtures', 'ups', 'success_response.xml')
      when :ups_error then File.join(File.dirname(__FILE__), 'fixtures', 'ups', 'error_response.xml')
      when :fedex_success then File.join(File.dirname(__FILE__), 'fixtures', 'fedex', 'success_response.xml')
      when :fedex_error then File.join(File.dirname(__FILE__), 'fixtures', 'fedex', 'error_response.xml')
      else raise "Invalid fixture name."
    end
    f = File.open(file_name, 'r')
    data = ""; f.lines.each do |line| data += line; end
    f.close
    return data
  end
end
