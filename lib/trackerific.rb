require 'dependencies'

require 'trackerific/version'
require 'trackerific/environment'
require 'trackerific/error'
require 'trackerific/details'
require 'trackerific/event'
require 'trackerific/soap'
require 'trackerific/builders'
require 'trackerific/parsers'
require 'trackerific/services'

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
