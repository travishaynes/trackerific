module Trackerific
  require 'savon'
  
  class FedEx < Base
    include Trackerific::SoapClient
    
    def required_options
      [:account, :meter, :key, :password]
    end
    
    def track_package(package_id)
      super
      begin
        tracking_response = soap_client.request :track do
          soap.input = 'wsdl:TrackRequest'
          soap.body = soap_body
        end.to_hash
      rescue Savon::HTTP::Error => e
        raise Trackerific::Error, e.message
      end
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
          :Intermediate => '0',
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
