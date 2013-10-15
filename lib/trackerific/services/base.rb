module Trackerific
  module Services
    class Base
      class << self
        attr_accessor :name

        # Registers the service with Trackerific
        # @api semipublic
        def register(name)
          self.name = name.to_sym
          Trackerific::Services[self.name] = self
        end

        def track(id)
          options = Trackerific.configuration[self.name] || {}
          new(options).track(id)
        end

        # Checks if the given package ID can be tracked by this service
        # @param [String] id The package ID
        # @return [Boolean] true when this service can track the given ID
        def can_track?(id)
          package_id_matchers.each {|m| return true if id =~ m }
          false
        end

        # An Array of Regexp that matches valid package ids for the service
        # @api semipublic
        def package_id_matchers
          raise NotImplementedError,
            "You must implement this method in your service", caller
        end
      end
    end

    # Gets the tracking information for the package from the server
    # @param [String] id The package identifier
    # @return [Trackerific::Details] The tracking details
    # @api semipublic
    def track(id)
      raise NotImplementedError,
        "You must implement this method in your service", caller
    end
  end
end
