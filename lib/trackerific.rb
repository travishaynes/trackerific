# Trackerific is a UPS, FedEx and USPS tracking provider.
module Trackerific
  require 'rails'
  require 'trackerific_details'
  require 'trackerific_event'
  
  # Raised if something other than tracking information is returned.
  class Error < StandardError; end
  
  # Base class for Trackerific package tracking services.
  class Base
    # Creates a new instance of Trackerific::Base with required options
    # @api private
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
    
    # Gets the tracking information for the package from the server
    # @param [String] package_id the package identifier
    # @return [Trackerific::Details] the tracking details
    # @example Override this method in your custom tracking provider to implement tracking
    #   module Trackerific
    #     class MyTrackingProvider < Base
    #       def track_package
    #         Trackerific::Details.new(
    #           "summary of tracking events",
    #           [Trackerific::Event.new(Time.now, "summary", "location")]
    #         )
    #       end
    #     end
    #   end
    # @api public
    def track_package(package_id)
      @package_id = package_id
    end
    
    protected
    
    # An array of options that are required to create a new instance of this class
    # @return [Array] the required options
    # @example Override this method in your custom tracking provider to enforce some options
    #   module Trackerific
    #     class MyTrackingProvider < Base
    #       def required_options
    #         [:all, :these, :are, :required]
    #       end
    #     end
    #   end
    # @api private
    def required_options
      []
    end
    
  end
  
  require 'usps'
  require 'fedex'
  require 'ups'
  
  # Checks a string for a valid package tracking service
  # @param [String] package_id the package identifier
  # @return [Trackerific::Base] the Trackerific class that can track the given
  #   package id, or nil if none found.
  # @example Find out which service provider will track a valid FedEx number
  #   include Trackerific
  #   tracking_service "183689015000001" # => Trackerific::FedEx
  # @api public
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
