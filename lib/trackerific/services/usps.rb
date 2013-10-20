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

        case Trackerific.env
        when 'production'
          config.endpoint = '/ShippingAPI.dll'
          config.base_uri = 'http://production.shippingapis.com'
        else
          config.endpoint = '/ShippingAPITest.dll'
          config.base_uri = 'http://testing.shippingapis.com'
        end
      end

      protected

      def request(id)
        self.class.get(config.endpoint, http_query(id))
      end

      def http_query(id)
        { query: { :API => 'TrackV2', :XML => builder(id).xml }.to_query }
      end
    end
  end
end
