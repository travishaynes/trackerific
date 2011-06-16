module Trackerific
  # Base class for Trackerific services
  class Service
    include OptionsHelper
    
    # Creates a new instance of Trackerific::Service with required options
    # @api private
    def initialize(options = {})
      validate_options options, self.class.required_options
      @options = options
    end
    
    # Gets the tracking information for the package from the server
    # @param [String] package_id the package identifier
    # @return [Trackerific::Details] the tracking details
    # @example Override this method in your custom tracking service to implement tracking
    #   module Trackerific
    #     class MyTrackingService < Trackerific::Service
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
    
    class << self
    
      # An Array of Regexp that matches valid package identifiers for your service
      # @example Override this method in your custom tracking service
      #   module Trackerific
      #     class MyTrackingService < Service
      #       def self.package_id_matchers
      #         [ /^.Z/, /^[HK].{10}$/ ]  # matchers for UPS package identifiers
      #       end
      #     end
      #   end
      # @return [Array, Regexp] an array of regular expressions
      # @api semipublic
      def package_id_matchers
        nil
      end
      
      # An array of options that are required to create a new instance of this class
      # @return [Array] the required options
      # @example Override this method in your custom tracking service to enforce some options
      #   module Trackerific
      #     class MyTrackingService < Service
      #       def self.required_options
      #         [:all, :these, :are, :required]
      #       end
      #     end
      #   end
      # @api semipublic
      def required_options
        []
      end
      
      # Provides a humanized string that provides the name of the service (i.e. "FedEx")
      # @return [String] the service name
      # @note This defaults to using the class name.
      # @example Override this method in your custom tracking service to provide a name
      #   module Trackerific
      #     class MyTrackingService < Service
      #       def self.service_name
      #         "my custom tracking service"
      #       end
      #     end
      #   end
      # @api public
      def service_name
        self.to_s.split("::")[1]
      end
      
    end
    
  end
end
