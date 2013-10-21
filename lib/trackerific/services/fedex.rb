class Trackerific::Services::FedEx < Trackerific::Services::Base
  register :fedex, as: :SOAP

  configure do |config|
    config.track_operation = :track
    config.builder = Trackerific::Builders::FedEx
    config.parser = Trackerific::Parsers::FedEx
    config.wsdl = 'fedex/TrackService_v8'
    config.package_id_matchers = [ /^[0-9]{15}$/ ]
  end
end
