module Trackerific
  require 'savon'
  
  module SoapClient
    def soap_client
      return @soap_client unless @soap_client.nil?
      wsdl_document = "#{::File.dirname(__FILE__)}/wsdl/#{self.class.to_s.rpartition("::")[2].downcase}/#{Rails.env}.wsdl"
      @soap_client = Savon::Client.new do
        wsdl.document = wsdl_document
      end
    end
  end
end
