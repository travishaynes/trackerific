module Trackerific
  module Services
    class FedEx < Base
      require 'trackerific/builders/fedex'
      require 'trackerific/parsers/fedex'

      include Concerns::XML, HTTParty

      register :fedex

      self.xml_endpoint = "/GatewayDC"
      self.xml_parser = Parsers::FedEx
      self.xml_builder = Builders::FedEx
      self.xml_builder_keys = [:account, :meter]

      format :xml

      base_uri "https://gateway.fedex.com"

      def self.package_id_matchers
        [ /^[0-9]{15}$/ ]
      end
    end
  end
end
