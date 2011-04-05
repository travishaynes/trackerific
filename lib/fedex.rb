module Trackerific
  class FedEx
    TEST_WSDL = "%s/lib/wsdl/fedex/test/TrackService_v4.wsdl" % Rails.root
    PROD_WSDL = "%s/lib/wsdl/fedex/prod_track_service_v4.wsdl" % Rails.root
    
    def initialize(account, meter, key, password)
      @account = account
      @meter = meter
      @key = key
      @password = password
      @soap_client = Savon::Client.new do
        wsdl.document = Rails.env.production? ? PROD_WSDL : TEST_WSDL
      end
    end
    
    def track(package_id)
      @package_id = package_id
      tracking_response = @soap_client.request :track do
        soap.input = 'wsdl:TrackRequest'
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
      { 'wsdl:WebAuthenticationDetail' => {
          'wsdl:UserCredential' => {
            'wsdl:Key' => @key,
            'wsdl:Password' => @password,
            :order! => ['wsdl:Key', 'wsdl:Password']
          }
        },
        'wsdl:ClientDetail' => {
          'wsdl:AccountNumber' => @account,
          'wsdl:MeterNumber' => @meter
        },
        'wsdl:Version' => {
          'wsdl:ServiceId' => 'trck',
          'wsdl:Major' => '4',
          'wsdl:Intermediate' => '1',
          'wsdl:Minor' => '0'
        },
        'wsdl:PackageIdentifier' => {
          'wsdl:Value' => @package_id
          'wsdl:Type' => 'TRACKING_NUMBER_OR_DOORTAG',
          :order! => ['wsdl:Value', 'wsdl:Type']
        },
        'wsdl:IncludeDetailedScans' => 'true',
        :order! => [ 'wsdl:WebAuthenticationDetail', 'wsdl:ClientDetail', 'wsdl:Version', 'wsdl:PackageIdentifier', 'wsdl:IncludeDetailedScans']
      }
    end
    
  end
end
