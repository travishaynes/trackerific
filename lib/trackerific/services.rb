module Trackerific
  module Services
    @services = {}

    class << self
      # Finds a service by the given name
      # @param [Symbol] name The name of the service
      # @return A descendant of Trackerific::Services::Base or nil for no match
      # @api public
      def [](name)
        @services[name]
      end

      # Registers a service by the given name and class
      # @param [Symbol] name The name of the service
      # @param [Trackerific::Services::Base] _class The base class to register
      # @api public
      def []=(name, _class)
        unless _class.superclass == Trackerific::Services::Base
          raise ArgumentError,
            "Expected a Trackerific::Services::Base, got #{_class.inspect}",
            caller
        end

        @services[name] = _class
      end

      # Finds the tracking service(s) that are capable of tracking the given
      # package ID
      # @param [String] id The package identifier
      # @return [Array, Trackerific::Services::Base] The services that are
      # capable of tracking the given ID.
      # @example Find out which service providers can track a FedEx ID
      #   Trackerific::Services.find_by_package_id "183689015000001"
      # @api public
      def find_by_package_id(id)
        @services.map {|n,s| s if s.can_track?(id) }.compact
      end
    end

    module Concerns
      require 'trackerific/services/concerns/soap'
      require 'trackerific/services/concerns/xml'
    end

    require 'trackerific/services/base'
    require 'trackerific/services/fedex'
    require 'trackerific/services/ups'
    require 'trackerific/services/usps'
  end
end
