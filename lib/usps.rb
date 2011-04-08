module Trackerific
  require 'builder'
  require 'httparty'
  
  class USPS < Base
    HTTP_PATH = '/ShippingAPITest.dll'
    API = 'TrackV2'
    
    def initialize(options = {})
      super
      @options = options
    end
    
    def required_options
      [:user_id]
    end
    
    def track_package(package_id)
      super
      response = HTTP.get(HTTP_PATH, :query => {:API => API, :XML => build_xml_request}.to_query)
      response.error! unless response.code == 200
      raise Trackerific::Error, response['Error']['Description'] unless response['Error'].nil?
      raise Trackerific::Error, "Tracking information not found in response from server." if response['TrackResponse'].nil?
      tracking_info = response['TrackResponse']['TrackInfo']
      {
        :package_id => tracking_info['ID'],
        :summary => tracking_info['TrackSummary'],
        :details => tracking_info['TrackDetail']
      }
    end
    
    protected
    
    def build_xml_request
      tracking_request = ""
      builder = ::Builder::XmlMarkup.new(:target => tracking_request)
      builder.TrackRequest(:USERID => @options[:user_id]) do |t|
        t.TrackID(:ID => @package_id)
      end
      return tracking_request
    end
    
    private
    
    class HTTP
      include HTTParty
      format :xml
      base_uri case Rails.env
        when 'test', 'development' then 'http://testing.shippingapis.com'
        when 'production' then 'https://secure.shippingapis.com'
      end
    end
    
  end
  
end
