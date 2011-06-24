require 'rails'
require 'helpers/options_helper'
require 'trackerific/configuration'
require 'trackerific/service'
require 'trackerific/error'
require 'trackerific/details'
require 'trackerific/event'

# require all the Trackerific services
services_path = File.join(File.dirname(__FILE__), "trackerific", "services", "**", "*.rb")
Dir[File.expand_path(services_path)].each { |file| require file }

# Trackerific provides package tracking to Rails apps.
module Trackerific
  
  class << self
    # Gets a list of all Trackerific services
    # @return [Array, Symbol] the services
    # @api private
    def services
      # a service is any Trackerific class that descends from Trackerific::Service
      # [:UPS, :FedEx, :USPS, :MockService]
      @services ||= Trackerific.constants.reject { |const|
        const unless Trackerific.const_get(const).superclass == Trackerific::Service
      }
    end
    
    # Gets a Trackerific::Service class
    # @param [Symbol] name the name of the service
    # @return [Trackerific::Service] the service, or nil
    # @api private
    def service_get(name)
      services.each do |service|
        return Trackerific.const_get(service) if name == service.to_s.downcase.to_sym
      end
      return nil
    end
  end
  
  # Checks a string for a valid package tracking service
  # @param [String] package_id the package identifier
  # @return [Trackerific::Base] the Trackerific class that can track the given
  #   package id, or nil if none found.
  # @example Find out which service provider will track a valid FedEx number
  #   include Trackerific
  #   tracking_service "183689015000001" # => Trackerific::FedEx
  # @api public
  def tracking_service(package_id)
    # loop through all the services
    Trackerific.services.each do |service|
      # get the class associated with this service
      cls = Trackerific.const_get(service)
      # loop through all the packge id regular expressions
      cls.package_id_matchers.each do |matcher|
        # return this class if the regular expression matches
        return cls if package_id =~ matcher
      end unless cls.package_id_matchers.nil?
    end
    # if we've made it this far, nothing matched
    nil
  end
  
  # Tracks a package by determining its service from the package id
  # @param [String] package_id the package identifier
  # @return [Trackerific::Details] the tracking results
  # @raise [Trackerific::Error] raised when the server returns an error (invalid credentials, tracking package, etc.)
  # @example Track a package
  #   include Trackerific
  #   # make sure to configure Trackerific before hand with the different services credentials
  #   Trackerific.config do |config|
  #     config.fedex :meter => '123456789', :account => '123456789'
  #   end
  #   details = track_package "183689015000001"
  # @api public
  def track_package(package_id)
    # find the service that will be able to track this package
    service = tracking_service package_id
    raise Trackerific::Error, "Cannot find a service to track package id #{package_id}" if service.nil?
    # get the name of the service
    service_name = service.to_s.split('::')[1].downcase
    # get the default configuration for the service
    options = Trackerific.configuration.send service_name
    # track the package
    service.new(options).track_package package_id
  end
end
