module Trackerific
  module Services
    class FedEx < Base
      require 'trackerific/builders/fedex'
      require 'trackerific/parsers/fedex'

      include Concerns::SOAP

      register :fedex

      self.soap_track_operation = :track
      self.soap_builder = Builders::FedEx
      self.soap_parser = Parsers::FedEx
      self.soap_wsdl = 'fedex/TrackService_v8'

      def self.package_id_matchers
        [ /^[0-9]{15}$/ ]
      end
    end
  end
end
