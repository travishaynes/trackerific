require 'rails'
require 'trackerific/base'
require 'trackerific/error'
require 'trackerific/details'
require 'trackerific/event'
require 'trackerific/services/fedex'
require 'trackerific/services/ups'
require 'trackerific/services/usps'

module Trackerific
  # Checks a string for a valid package tracking service
  # @param [String] package_id the package identifier
  # @return [Trackerific::Base] the Trackerific class that can track the given
  #   package id, or nil if none found.
  # @example Find out which service provider will track a valid FedEx number
  #   include Trackerific
  #   tracking_service "183689015000001" # => Trackerific::FedEx
  # @api public
  def tracking_service(package_id)
    case package_id
      when /^.Z/, /^[HK].{10}$/ then Trackerific::UPS
      when /^96.{20}$/ then Trackerific::FedEx
      else case package_id.length
        when 13, 20, 22, 30 then Trackerific::USPS
        when 12, 15, 19 then Trackerific::FedEx
        else nil
      end
    end
  end
end
