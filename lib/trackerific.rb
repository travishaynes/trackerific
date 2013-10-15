require 'trackerific/version'
require 'trackerific/configuration'
require 'trackerific/error'
require 'trackerific/details'
require 'trackerific/event'
require 'trackerific/services'
require 'trackerific/services/base'

# add tracking services here
require 'trackerific/services/fedex'
require 'trackerific/services/ups'
require 'trackerific/services/usps'

module Trackerific
  class << self
    # Used to access the Trackerific service credentials
    # @api public
    def configuration
      Trackerific::Configuration.config
    end

    # Use to configure Trackerific service credentials
    # @example Configure FedEx credentials
    #   Trackerific.configure do |config|
    #     config.fedex account: 'account', meter: '123456789'
    #   end
    # @api public
    def configure(&block)
      Trackerific::Configuration.configure {|config| yield(config) }
    end

    # Looks up which service(s) can track the given ID and tracks it.
    # @param [String] id The package identifier
    # @return [Array, Trackerific::Details] The tracking results
    # @raise [Trackerific::Error] Raised when the server returns an error
    # @api public
    def track(id)
      Trackerific::Services.find_by_package_id(id).map do |service|
        service.new.track(id)
      end
    end
  end
end
