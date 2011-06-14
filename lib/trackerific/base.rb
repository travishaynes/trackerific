module Trackerific
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
end
