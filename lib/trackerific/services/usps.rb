require 'date'

module Trackerific
  require 'builder'
  require 'httparty'
  
  # Provides package tracking support for USPS.
  class USPS < Trackerific::Service
    # setup HTTParty
    include HTTParty
    format :xml
    base_uri Rails.env.production? ? "http://production.shippingapis.com" : "http://testing.shippingapis.com"
    
    class << self
      # An Array of Regexp that matches valid USPS package IDs
      # @return [Array, Regexp] the regular expression
      # @api private
      def package_id_matchers
        [ /^E\D{1}\d{9}\D{2}$|^9\d{15,21}$/ ]
      end    
      
      # The required options for tracking a UPS package
      # @return [Array] the required options for tracking a UPS package
      # @api private
      def required_options
        [:user_id]
      end
    end
    
    # Tracks a USPS package
    # @param [String] package_id the package identifier
    # @return [Trackerific::Details] the tracking details
    # @raise [Trackerific::Error] raised when the server returns an error (invalid credentials, tracking package, etc.)
    # @example Track a package
    #   usps = Trackerific::USPS.new user_id: 'user'
    #   details = ups.track_package("EJ958083578US")
    # @api public    
    def track_package(package_id)
      super
      # connect to the USPS shipping API via HTTParty
      response = self.class.get(
        Rails.env.production? ? "/ShippingAPI.dll" : "/ShippingAPITest.dll",
        :query => {
          :API => 'TrackV2',
          :XML => build_xml_request
        }.to_query
      )
      # throw any HTTP errors
      response.error! unless response.code == 200
      # raise a Trackerific::Error if there is an error in the response, or if the
      # tracking response is malformed
      raise Trackerific::Error, response['Error']['Description'] unless response['Error'].nil?
      raise Trackerific::Error, "Tracking information not found in response from server." if response['TrackResponse'].nil?
      # get the tracking information from the response, and convert into a
      # Trackerific::Details
      tracking_info = response['TrackResponse']['TrackInfo']
      details = []
      tracking_info['TrackDetail'].each do |d|
        # each tracking detail is a string in this format:
        # MM DD HH:MM am/pm DESCRIPTION CITY STATE ZIP.
        # unfortunately, it will not be possible to tell the difference between
        # the location, and the summary. So, for USPS, the location will be in
        # the summary
        d = d.split(" ")
        date = DateTime.parse(d[0..3].join(" "))
        desc = d[4..d.length].join(" ")
        details << Trackerific::Event.new(date, desc, "")
      end unless tracking_info['TrackDetail'].nil?
      # return the details
      Trackerific::Details.new(
        tracking_info['ID'],
        tracking_info['TrackSummary'],
        details
      )
    end
    
    protected
    
    # Builds an XML request to send to USPS
    # @return [String] the xml request
    # @api private
    def build_xml_request
      xml = ""
      # set up the Builder
      builder = ::Builder::XmlMarkup.new(:target => xml)
      # build the request
      builder.TrackRequest(:USERID => @options[:user_id]) do |t|
        t.TrackID(:ID => @package_id)
      end
      # return the XML
      xml
    end
    
  end
  
end
