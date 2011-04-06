module Trackerific
  class Error < StandardError
  end
  
  class Base
    def initialize(options = {})
      required = required_options
      required.each do |k|
        raise ArgumentError.new("Missing required parameter: #{k}") unless options.has_key?(k)
      end
      options.each do |k, v|
        raise ArgumentError.new("Invalid parameter: #{k}") unless required.include?(k)
      end
    end
    
    def required_options
      []
    end
    
    def track_package(package_id)
      @package_id = package_id
    end
  end
  
  require 'usps'
  require 'fedex'
  #require 'ups'
end
