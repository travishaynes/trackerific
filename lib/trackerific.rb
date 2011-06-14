require 'rails'
require 'trackerific/base'
require 'trackerific/error'
require 'trackerific/details'
require 'trackerific/event'

# require all the Trackerific services
services_path = File.join(File.dirname(__FILE__), "trackerific", "services", "**", "*.rb")
Dir[File.expand_path(services_path)].each { |file| require file }

# Trackerific provides package tracking to Rails apps.
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
    # loop through each constant in Trackerific
    Trackerific.constants.each do |const|
      # get the constant's class
      cls = Trackerific.const_get(const)
      # check if it descends from Trackerific::Base
      if cls.superclass == Trackerific::Base
        # loop through each package id matcher
        cls.package_id_matchers.each do |matcher|
          # return the class if it matches
          return cls if package_id =~ matcher
        end
      end
    end
    # if we've made it this far, nothing matched
    nil
  end
  
  # TODO: Tracks a package by determining its service from the package id
  # @param [String] package_id the package identifier
  # @return [Trackerific::Details] the tracking results
  # @raise [Trackerific::Error] raised when the server returns an error (invalid credentials, tracking package, etc.)
  # @example Track a package
  #   include Trackerific
  #   details = track_package("183689015000001")
  # @api public
#  def track_package(package_id)
#    service = tracking_service(package_id)
#    
#  end
end
