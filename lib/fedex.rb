module Trackerific
  require 'savon'
  
  class FedEx < Base
    TEST_WSDL = "%s/wsdl/fedex/test_track_service_v4.wsdl" % ::File.dirname(__FILE__)
    PROD_WSDL = "%s/wsdl/fedex/prod_track_service_v4.wsdl" % ::File.dirname(__FILE__)
    
    def initialize(options = {})
      super
      @options = options
      @soap_client = Savon::Client.new do
        wsdl.document = Rails.env.production? ? PROD_WSDL : TEST_WSDL
      end
    end
    
    def required_options
      [:account, :meter, :key, :password]
    end
    
    def track_package(package_id)
      super
      tracking_response = @soap_client.request :track do
        soap.input = 'wsdl:Track'
        soap.body = soap_body
      end.to_hash
      if tracking_response[:track_reply][:highest_severity] == 'ERROR'
        raise Trackerific::Error, tracking_response[:track_reply][:notifications][:message]
      end
      return {
        :package_id => package_id,
        :summary    => tracking_response[:track_reply][:transaction_detail],
        :details    => tracking_response[:track_reply][:track_details]
      }
    end
    
    protected
    
    def soap_body
      {
        :WebAuthenticationDetail => {
          :UserCredential => {
            :Key => @options[:key],
            :Password => @options[:password],
            :order! => [:Key, :Password]
          }
        },
        :ClientDetail => {
          :AccountNumber => @options[:account],
          :MeterNumber => @options[:meter]
        },
        :Version => {
          :ServiceId => 'trck',
          :Major => '4',
          :Intermediate => '1',
          :Minor => '0'
        },
        :PackageIdentifier => {
          :Value => @package_id,
          :Type => 'TRACKING_NUMBER_OR_DOORTAG',
          :order! => [:Value, :Type]
        },
        :IncludeDetailedScans => 'true',
        :order! => [:WebAuthenticationDetail, :ClientDetail, :Version, :PackageIdentifier, :IncludeDetailedScans]
      }
    end
    
  end
end
