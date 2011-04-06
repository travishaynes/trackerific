module Trackerific
  require 'net/http'
  require 'builder'
  require 'xmlsimple'
  
  class USPS < Base
    TEST_SCHEME = 'http'
    PROD_SCHEME = 'https'
    TEST_HOST = 'testing.shippingapis.com'
    PROD_HOST = 'secure.shippingapis.com'
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
      http_response = Net::HTTP.get_response(build_uri)
      http_response.error! unless http_response.is_a? Net::HTTPSuccess
      tracking_response = XmlSimple.xml_in(http_response.body)
      if tracking_response['TrackInfo'].nil?
        raise Trackerific::Error.new, tracking_response['Description'][0]
      end
      tracking_info = tracking_response['TrackInfo'][0]
      return {
        :package_id => tracking_info['ID'],
        :summary    => tracking_info['TrackSummary'][0],
        :details    => tracking_info['TrackDetail']
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
    
    def build_uri
      URI::HTTP.build({
        :scheme => Rails.env.production? ? PROD_SCHEME : TEST_SCHEME,
        :host   => Rails.env.production? ? PROD_HOST : TEST_HOST,
        :path   => HTTP_PATH,
        :query  => {:API => API, :XML => build_xml_request}.to_query
      })
    end
    
  end
  
end
