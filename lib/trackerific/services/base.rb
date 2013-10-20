module Trackerific
  module Services
    class Base
      class << self
        attr_accessor :name
        attr_accessor :config

        # Configures the service
        # @api semipublic
        def configure(&block)
          yield self.config = OpenStruct.new
        end

        # Registers the service with Trackerific
        # @api semipublic
        def register(name)
          self.name = name.to_sym
          Trackerific::Services[self.name] = self
        end

        # Creates a new instance and calls #track with the given id
        # @param id The package identifier
        # @return Either a Trackerific::Details or Trackerific::Error
        def track(id)
          new.track(id)
        end

        # Reads the credentials from Trackerific.config
        # @return [Hash] The service's credentials
        def credentials
          Trackerific.config[name]
        end

        # Checks if the given package ID can be tracked by this service
        # @param [String] id The package ID
        # @return [Boolean] true when this service can track the given ID
        # @note This will always be false if no credentials were found for the
        # service in Trackerific.config
        def can_track?(id)
          return false if credentials.nil?
          package_id_matchers.each {|m| return true if id =~ m }
          false
        end

        # An Array of Regexp that matches valid package ids for the service
        # @api semipublic
        def package_id_matchers
          config.package_id_matchers
        end
      end

      def initialize(credentials=self.class.credentials)
        @credentials = credentials

        if credentials.nil?
          raise Trackerific::Error,
            "Missing credentials for #{self.class.name}", caller
        end
      end

      def config
        self.class.config
      end
    end
  end
end
