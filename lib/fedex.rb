require 'httparty'

module Trackerific
  
  # Provides package tracking support for FedEx
  class FedEx < Base
    # setup HTTParty
    include ::HTTParty
    format :xml
    base_uri "https://gateway.fedex.com"
    
    # @return [Array] required options for tracking a FedEx package are :account
    #   and :meter
    def required_options
      [:account, :meter]
    end
    
    # Tracks a FedEx package.
    # A Trackerific::Error is raised when a package cannot be tracked.
    # @return [Trackerific::Details] the tracking details
    def track_package(package_id)
      super
      # request tracking information from FedEx via HTTParty
      http_response = self.class.post "/GatewayDC", :body => build_xml_request
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
        events << Trackerific::Event.new(date, desc, "#{addr["StateOrProvinceCode"]} #{addr["PostalCode"]}")
      end
      # Return a Trackerific::Details containing all the events
      Trackerific::Details.new(
        details["TrackingNumber"],
        details["StatusDescription"],
        events
      )
    end
    
    protected
    
    # Builds the XML request to send to FedEx
    # @return [String] a FDXTrack2Request XML
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
