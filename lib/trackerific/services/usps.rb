module Trackerific
  module Services
    class USPS < Base
      require 'trackerific/builders/usps'
      require 'trackerific/parsers/usps'

      include Concerns::XML, HTTParty

      register :usps

      self.xml_parser = Parsers::USPS
      self.xml_builder = Builders::USPS

      case Trackerific.env
      when 'production'
        self.xml_endpoint = '/ShippingAPI.dll'
        base_uri 'http://production.shippingapis.com'
      else
        self.xml_endpoint = '/ShippingAPITest.dll'
        base_uri 'http://testing.shippingapis.com'
      end

      format :xml

      def self.package_id_matchers
        [ /^E\D{1}\d{9}\D{2}$|^9\d{15,21}$/ ]
      end

      protected

      def http_response(id)
        http_response = self.class.get(self.class.xml_endpoint, http_query(id))
      end

      def http_query(id)
        { query: { :API => 'TrackV2', :XML => builder(id).xml }.to_query }
      end
    end
  end
end
