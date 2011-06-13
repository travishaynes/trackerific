module Trackerific
  require 'rails'
  
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
      @options = options
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
  require 'ups'
  
  def tracking_service(package_id)
    case package_id
      when /^.Z/, /^[HK].{10}$/ then Trackerific::UPS
      when /^96.{20}$/ then Trackerific::FedEx
      else case package_id.length
        when 13, 20, 22, 30 then Trackerific::USPS
        when 12, 15, 19 then Trackerific::FedEx
        else nil
      end
    end
  end
end
