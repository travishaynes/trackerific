module Trackerific
  # Provides a dynamic configuration
  class Configuration
    include OptionsHelper
    # Creates a new instance of Trackerific::Configuration
    # @api private
    def initialize
      @options = {}
    end
    # Overriding the method_missing method allows dynamic methods
    # @return [Hash]
    # @api private
    def method_missing(sym, *args, &block)
      # Get a list of all the services (convert symbols to lower case)
      services = Trackerific.services.map { |service| service.to_s.downcase.to_sym }
      # Do not accept any configuration values for anything except services
      raise NoMethodError unless services.include? sym
      # Only accept Hashes
      unless args.empty?
        raise ArgumentError unless args[0].class == Hash
        # Validate configuration values against the required options for that service
        validate_options args[0], Trackerific.service_get(sym).required_options
        # Store the configuration options
        @options[sym] = args[0]
      end
      # return the configuration options
      @options[sym]
    end
  end
  class << self
    # Stores the configuration options for Trackerific
    # @return [Trackerific::Configuration]
    # @api private
    def configuration
      @configuration ||= Trackerific::Configuration.new
    end
    # Configures Trackerific
    # @return [Trackerific::Configuration]
    # @example Defining credentials
    #   Trackerific.configure do |config|
    #     config.fedex :meter => '123456789', :account => '123456789'
    #   end
    # @api public
    def configure
      yield configuration
      configuration
    end
  end
end
