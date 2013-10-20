module Trackerific
  module Services
    class USPS < Base
      require 'trackerific/builders/usps'
      require 'trackerific/parsers/usps'

      include Concerns::XML

      register :usps

      configure do |config|
        config.parser = Parsers::USPS
        config.builder = Builders::USPS
        config.package_id_matchers = [ /^E\D{1}\d{9}\D{2}$|^9\d{15,21}$/ ]
        config.endpoint = case Trackerific.env
        when 'production' then '/ShippingAPI.dll'
        else '/ShippingAPITest.dll'
        end
      end

      base_uri case Trackerific.env
      when 'production' then 'http://production.shippingapis.com'
      else 'http://testing.shippingapis.com'
      end

      format :xml

      protected

      def http_response(id)
        http_response = self.class.get(config.endpoint, http_query(id))
      end

      def http_query(id)
        { query: { :API => 'TrackV2', :XML => builder(id).xml }.to_query }
      end
    end
  end
end
