module Trackerific
  module Services
     # Provides a mock service for using in test and development
    class MockService < Base
      require 'date'

      self.register :mock_service

      # Regular expression matchers for mocked Trackerific service
      # @return [Array, Regexp] the regular expression
      # @api private
      def self.package_id_matchers
        [ /XXXXXXXXXX/, /XXXxxxxxxx/ ]
      end

      # Sets up a mocked package details
      # @param [String] package_id the package identifier
      # @return [Trackerific::Details] the tracking details
      # @raise [Trackerific::Error] raised when the server returns an error
      # @example Track a package
      #   service = Trackerific::Services::MockedService.new
      #   details = service.track("XXXXXXXXXX") # => valid response
      #   details = service.track("XXXxxxxxxx") # => throws a Trackerific::Error exception
      # @api public
      def track(id)
        if id == "XXXXXXXXXX"
          Trackerific::Details.new(id, "Your package was delivered.",
            [
              Trackerific::Event.new(
                :date         => Date.today,
                :description  => "Package delivered.",
                :location     => "SANTA MARIA, CA"
              ),
              Trackerific::Event.new(
                :date         => Date.today - 1,
                :description  => "Package scanned.",
                :location     => "SANTA BARBARA, CA"
              ),
              Trackerific::Event.new(
                :date         => Date.today - 2,
                :description  => "Package picked up for delivery.",
                :location     => "LOS ANGELES, CA"
              )
            ]
          )
        else
          raise Trackerific::Error, "Package not found."
        end
      end
    end
  end
end
