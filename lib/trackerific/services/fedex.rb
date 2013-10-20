module Trackerific
  module Services
    class FedEx < Base
      require 'trackerific/builders/fedex'
      require 'trackerific/parsers/fedex'

      include Concerns::SOAP

      register :fedex

      configure do |config|
        config.track_operation = :track
        config.builder = Builders::FedEx
        config.parser = Parsers::FedEx
        config.wsdl = 'fedex/TrackService_v8'
        config.package_id_matchers = [ /^[0-9]{15}$/ ]
      end
    end
  end
end
