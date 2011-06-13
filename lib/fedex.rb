require 'httparty'

module Trackerific
  
  # Provides package tracking support for FedEx
  class FedEx < Base
    include ::HTTParty
    format :xml
    base_uri "https://gateway.fedex.com"
    
    # @return [Array] required options for tracking a FedEx package are :account
    #   and :meter.
    def required_options
      [:account, :meter]
    end
    
    # Tracks a FedEx package.
    #
    # A Trackerific::Error is raised when a package cannot be tracked.
    #
    # @return [Trackerific::Details] the tracking details
    def track_package(package_id)
      super
      http_response = self.class.post "/GatewayDC", :body => build_xml_request
      http_response.error! unless http_response.code == 200
      
      track_reply = http_response["FDXTrack2Reply"]
      raise Trackerific::Error, track_reply["Error"]["Message"] unless track_reply["Error"].nil?
      
      details = track_reply["Package"]
      events = []
      details["Event"].each do |e|
        date = Time.parse("#{e["Date"]} #{e["Time"]}")
        desc = e["Description"]
        addr = e["Address"]
        # Adds event in this format:
        # MM DD HH:MM am/pm Description City State Zip
        events << Trackerific::Event.new(date, desc, "#{addr["StateOrProvinceCode"]} #{addr["PostalCode"]}")
      end
      
      Details.new(
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
      xmlns_api = "http://www.fedex.com/fsmapi"
      xmlns_xsi = "http://www.w3.org/2001/XMLSchema-instance"
      xsi_noNSL = "FDXTrack2Request.xsd"
      builder = ::Builder::XmlMarkup.new(:target => xml)
      builder.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
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
      return xml
    end
    
  end
end
