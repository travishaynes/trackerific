require 'date'

module Trackerific
  require 'httparty'
  
  # Provides package tracking support for UPS.
  class UPS < Trackerific::Service
    # setup HTTParty
    include ::HTTParty
    format :xml
    # use the test site for Rails development, production for everything else
    base_uri defined?(Rails) ? case Rails.env
      when 'test','development' then 'https://wwwcie.ups.com/ups.app/xml'
      when 'production' then 'https://www.ups.com/ups.app/xml'
    end : 'https://www.ups.com/ups.app/xml'
    
    class << self
      # An Array of Regexp that matches valid UPS package IDs
      # @return [Array, Regexp] the regular expression
      # @api private
      def package_id_matchers
        [ /^.Z/, /^[HK].{10}$/ ]
      end    
      # The required parameters for tracking a UPS package
      # @return [Array] the required parameters for tracking a UPS package
      # @api private
      def required_parameters
        [:key, :user_id, :password]
      end
    end
    
    # Tracks a UPS package
    # @param [String] package_id the package identifier
    # @return [Trackerific::Details] the tracking details
    # @raise [Trackerific::Error] raised when the server returns an error (invalid credentials, tracking package, etc.)
    # @example Track a package
    #   ups = Trackerific::UPS.new key: 'api key', user_id: 'user', password: 'secret'
    #   details = ups.track_package("1Z12345E0291980793")
    # @api public
    def track_package(package_id)
      super
      # connect to UPS via HTTParty
      http_response = self.class.post('/Track', :body => build_xml_request)
      # throw any HTTP errors
      http_response.error! unless http_response.code == 200
      # Check the response for errors, return a Trackerific::Error, or parse
      # the response from UPS and return a Trackerific::Details
      case http_response['TrackResponse']['Response']['ResponseStatusCode']
        when "0" then raise Trackerific::Error, parse_error_response(http_response)
        when "1" then return parse_success_response(http_response)
        else raise Trackerific::Error, "Invalid response code returned from server."
      end
    end
    
    protected
    
    # Parses the response from UPS
    # @return [Trackerific::Details]
    # @api private
    def parse_success_response(http_response)
      # get the activity from the UPS response
      activity = http_response['TrackResponse']['Shipment']['Package']['Activity']
      # if there's only one activity in the list, we need to put it in an array
      activity = [activity] if activity.is_a? Hash
      # UPS does not provide a summary, so we'll just use the last tracking status
      summary = activity.first['Status']['StatusType']['Description'].titleize
      events = []
      activity.each do |a|
        # the time format from UPS is HHMMSS, which cannot be directly converted
        # to a Ruby time.
        hours   = a['Time'][0..1]
        minutes = a['Time'][2..3]
        seconds = a['Time'][4..5]
        date    = Date.parse(a['Date'])
        date    = DateTime.parse("#{date} #{hours}:#{minutes}:#{seconds}")
        desc    = a['Status']['StatusType']['Description'].titleize
        loc     = a['ActivityLocation']['Address'].map {|k,v| v}.join(" ")
        events << Trackerific::Event.new(
          :date         => date,
          :description  => desc,
          :location     => loc
        )
      end
      
      Trackerific::Details.new(
        :package_id => @package_id,
        :summary    => summary,
        :events     => events
      )
    end
    
    # Parses a UPS tracking response, and returns any errors
    # @return [String] the UPS tracking error
    # @api private
    def parse_error_response(http_response)
      http_response['TrackResponse']['Response']['Error']['ErrorDescription']
    end
    
    # Builds the XML request to send to UPS for tracking a package
    # @return [String] the XML request
    # @api private
    def build_xml_request
      xml = ""
      builder = ::Builder::XmlMarkup.new(:target => xml)
      builder.AccessRequest do |ar|
        ar.AccessLicenseNumber @options[:key]
        ar.UserId @options[:user_id]
        ar.Password @options[:password]
      end
      builder.TrackRequest do |tr|
        tr.Request do |r|
          r.RequestAction 'Track'
          r.RequestOption 'activity'
        end
        tr.TrackingNumber @package_id
      end
      return xml
    end
  end
end
