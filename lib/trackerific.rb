require 'active_support'
require 'active_support/core_ext/object/to_query'
require 'securerandom'
require 'date'
require 'savon'
require 'httparty'
require 'builder'
require 'trackerific/version'
require 'trackerific/environment'
require 'trackerific/error'
require 'trackerific/details'
require 'trackerific/event'
require 'trackerific/soap/wsdl'
require 'trackerific/builders/base/soap'
require 'trackerific/builders/base/xml'
require 'trackerific/parsers/base'
require 'trackerific/services/concerns/soap'
require 'trackerific/services/concerns/xml'
require 'trackerific/services'
require 'trackerific/services/base'

# add tracking services here
require 'trackerific/services/fedex'
require 'trackerific/services/ups'
require 'trackerific/services/usps'

module Trackerific
  include ActiveSupport::Configurable

  class << self
    # Looks up which service(s) can track the given ID and tracks it.
    # @param [String] id The package identifier
    # @return [Array, Trackerific::Details] The tracking results
    # @raise [Trackerific::Error] Raised when the server returns an error
    # @api public
    def track(id)
      Trackerific::Services.find_by_package_id(id).map {|s| s.track(id) }
    end
  end
end
