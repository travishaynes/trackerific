module Trackerific
  require 'savon'
  
  module SoapClient
    def soap_client
      return @soap_client unless @soap_client.nil?
      
      root_path     = "#{::File.dirname(__FILE__)}"
      class_name    = self.class.to_s.rpartition("::")[2].downcase
      wsdl_filename = Rails.env.production? ? "production.wsdl" : "development.wsdl"
      wsdl_document = "#{root_path}/wsdl/#{class_name}/#{wsdl_filename}"
      
      @soap_client = Savon::Client.new do
        wsdl.document = wsdl_document
      end
    end
  end
end
