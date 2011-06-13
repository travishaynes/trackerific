# Trackerific is a UPS, FedEx and USPS tracking provider.
module Trackerific
  require 'rails'
  require 'trackerific_details'
  require 'trackerific_event'
  
  # Raised if something other than tracking information is returned.
  class Error < StandardError; end
  
  # Base class for Trackerific package tracking services.
  class Base
    def initialize(options = {})
      required = required_options
      # make sure all the required options exist
      required.each do |k|
        raise ArgumentError.new("Missing required parameter: #{k}") unless options.has_key?(k)
      end
      # make sure no invalid options exist
      options.each do |k, v|
        raise ArgumentError.new("Invalid parameter: #{k}") unless required.include?(k)
      end
      @options = options
    end
    
    # Override this method if your subclass has required options.
    # @return [Array] the required options
    def required_options
      []
    end
    
    # Override this method in your subclass to implement tracking a package.
    # @return [Hash] the tracking details
    def track_package(package_id)
      @package_id = package_id
    end
  end
  
  require 'usps'
  require 'fedex'
  require 'ups'
  
  # Checks a string for a valid package identifier, and returns a Trackerific
  # class that should be able to track the package.
  #
  # @param [String] the package identifier.
  # @return [Trackerific::Base] the Trackerific class that can track the given
  #   package id, or nil if none found.
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
