require 'httparty'

module Trackerific
  
  class FedEx < Base
    include ::HTTParty
    format :xml
    base_uri "https://gateway.fedex.com"
    
    def required_options
      [:account, :meter]
    end
    
    def track_package(package_id)
      super
      http_response = self.class.post "/GatewayDC", :body => build_xml_request
      http_response.error! unless http_response.code == 200
      
      track_reply = http_response["FDXTrack2Reply"]
      raise Trackerific::Error, track_reply["Error"]["Message"] unless track_reply["Error"].nil?
      
      details = track_reply["Package"]
      events = []
      details["Event"].each do |e|
        date = Time.parse("#{e["Date"]} #{e["Time"]}").strftime('%b %d %I:%M %P')
        desc = e["Description"]
        addr = e["Address"]
        # Adds event in this format:
        # MM DD HH:MM am/pm Description City State Zip
        events << "#{date} #{desc} #{addr["City"]} #{addr["StateOrProvinceCode"]} #{addr["PostalCode"]}"
      end
      
      return {
        :package_id => details["TrackingNumber"],
        :summary    => details["StatusDescription"],
        :details    => events
      }
    end
    
    protected
    
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
