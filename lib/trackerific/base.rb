module Trackerific
  # Base class for Trackerific package tracking services.
  class Base
    # Creates a new instance of Trackerific::Base with required options
    # @api private
    def initialize(options = {})
      required = self.class.required_options
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
    # @example Override this method in your custom tracking service to implement tracking
    #   module Trackerific
    #     class MyTrackingService < Base
    #       def track_package
    #         # your tracking code here
    #         Trackerific::Details.new(
    #           "summary of tracking events",
    #           [Trackerific::Event.new(Time.now, "summary", "location")]
    #         )
    #       end
    #     end
    #   end
    # @api semipublic
    def track_package(package_id)
      @package_id = package_id
    end
    
    # An Array of Regexp that matches valid package identifiers for your service
    # @example Override this method in your custom tracking service
    #   module Trackerific
    #     class MyTrackingService < Base
    #       def self.package_id_matchers
    #         [ /^.Z/, /^[HK].{10}$/ ]  # matchers for UPS package identifiers
    #       end
    #     end
    #   end
    # @return [Array, Regexp] an array of regular expressions
    # @api semipublic
    def self.package_id_matchers
      nil
    end
    
    # An array of options that are required to create a new instance of this class
    # @return [Array] the required options
    # @example Override this method in your custom tracking service to enforce some options
    #   module Trackerific
    #     class MyTrackingService < Base
    #       def self.required_options
    #         [:all, :these, :are, :required]
    #       end
    #     end
    #   end
    # @api semipublic
    def self.required_options
      []
    end
    
  end
end
