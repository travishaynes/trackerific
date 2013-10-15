require 'httparty'
require 'builder'

module Trackerific
  module Services
    class FedEx < Base
      include ::HTTParty

      format :xml
      base_uri "https://gateway.fedex.com"

      self.register :fedex

      # An Array of Regexp that matches valid FedEx package IDs
      # @return [Array, Regexp] the regular expression
      # @api private
      def self.package_id_matchers
        [ /^[0-9]{15}$/ ]
      end

      def initialize(options={})
        @options = options
      end

      # Tracks a FedEx package
      # @param [String] package_id the package identifier
      # @return [Trackerific::Details] the tracking details
      # @raise [Trackerific::Error] raised when the server returns an error (invalid credentials, tracking package, etc.)
      # @example Track a package
      #   fedex = Trackerific::FedEx.new :account => 'account', :meter => 'meter'
      #   details = fedex.track_package("183689015000001")
      # @api public
      def track(package_id)
        # request tracking information from FedEx via HTTParty
        http_response = self.class.post "/GatewayDC", body: build_xml_request
        # raise any HTTP errors
        http_response.error! unless http_response.code == 200
        # get the tracking information from the reply
        track_reply = http_response["FDXTrack2Reply"]
        # raise a Trackerific::Error if there is an error in the reply
        raise Trackerific::Error, track_reply["Error"]["Message"] unless track_reply["Error"].nil?
        # get the details from the reply
        details = track_reply["Package"]
        # convert them into Trackerific::Events
        events = []
        details["Event"].each do |e|
          date = Time.parse("#{e["Date"]} #{e["Time"]}")
          desc = e["Description"]
          addr = e["Address"]
          loc = "#{addr["StateOrProvinceCode"]} #{addr["PostalCode"]}"
          events << Trackerific::Event.new(date, desc, loc)
        end
        # Return a Trackerific::Details containing all the events
        Trackerific::Details.new(
          details["TrackingNumber"], details["StatusDescription"], events
        )
      end

      private

      # Builds the XML request to send to FedEx
      # @return [String] a FDXTrack2Request XML
      # @api private
      def build_xml_request
        xml = ""
        # the API namespace
        xmlns_api = "http://www.fedex.com/fsmapi"
        # the XSI namespace
        xmlns_xsi = "http://www.w3.org/2001/XMLSchema-instance"
        # the XSD namespace
        xsi_noNSL = "FDXTrack2Request.xsd"
        # create a new Builder to generate the XML
        builder = ::Builder::XmlMarkup.new(:target => xml)
        # add the XML header
        builder.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
        # Build, and return the request
        builder.FDXTrack2Request "xmlns:api"=>xmlns_api, "xmlns:xsi"=>xmlns_xsi, "xsi:noNamespaceSchemaLocation" => xsi_noNSL do |r|
          r.RequestHeader do |rh|
            rh.AccountNumber @options[:account]
            rh.MeterNumber @options[:meter]
          end
          r.PackageIdentifier do |pi|
            pi.Value @package_id
          end
          r.DetailScans true
        end
        xml
      end
    end
  end
end
