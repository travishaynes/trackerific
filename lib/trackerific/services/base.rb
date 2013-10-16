module Trackerific
  module Services
    class Base
      @name = nil

      class << self
        attr_accessor :name

        # Registers the service with Trackerific
        # @api semipublic
        def register(name)
          self.name = name.to_sym
          Trackerific::Services[self.name] = self
        end

        def track(id)
          new(credentials).track(id)
        end

        # Checks if the given package ID can be tracked by this service
        # @param [String] id The package ID
        # @return [Boolean] true when this service can track the given ID
        def can_track?(id)
          return false if credentials.nil?
          package_id_matchers.each {|m| return true if id =~ m }
          false
        end

        # An Array of Regexp that matches valid package ids for the service
        # @api semipublic
        def package_id_matchers
          raise NotImplementedError,
            "You must implement this method in your service", caller
        end

        def credentials
          Trackerific.configuration[self.name]
        end
      end

      def initialize(options={})
        @options = options
      end
    end
  end
end
