require 'date'

module Trackerific
  
  # Provides a mock service for using in test and development
  class MockService < Trackerific::Service
    
    class << self
      # Regular expression matchers for mocked Trackerific service
      # @return [Array, Regexp] the regular expression
      # @api private
      def package_id_matchers
        if defined?(Rails)
          return [ /XXXXXXXXXX/, /XXXxxxxxxx/ ] unless Rails.env.production?
        else
          return [ ] # no matchers in production mode
        end
      end
      
      # Returns an Array of required options used when creating a new instance
      # @return [Array] required options
      # @api private
      def required_options
        [ ]
      end
    end
    
    # Sets up a mocked package details
    # @param [String] package_id the package identifier
    # @return [Trackerific::Details] the tracking details
    # @raise [Trackerific::Error] raised when the server returns an error
    # @example Track a package
    #   service = Trackerific::MockedService.new
    #   details = service.track_package("XXXXXXXXXX") # => valid response
    #   details = service.track_package("XXXxxxxxxx") # => throws a Trackerific::Error exception
    # @api public
    def track_package(package_id)
      super
      if package_id == "XXXXXXXXXX"
        Trackerific::Details.new(
          package_id,
          "Your package was delivered.",
          [
            Trackerific::Event.new(Date.today, "Package delivered.", "SANTA MARIA, CA"),
            Trackerific::Event.new(Date.today - 1, "Package scanned.", "SANTA BARBARA, CA"),
            Trackerific::Event.new(Date.today - 2, "Package picked up for delivery.", "LOS ANGELES, CA")
          ]
        )
      else
        raise Trackerific::Error, "Package not found."
      end
    end
  end
end
