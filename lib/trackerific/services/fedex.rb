class Trackerific::Services::FedEx < Trackerific::Services::Base
  register :fedex, as: :SOAP

  configure do |config|
    config.track_operation = :track
    config.builder = Trackerific::Builders::FedEx
    config.parser = Trackerific::Parsers::FedEx
    config.wsdl = 'fedex/TrackService_v9'
    config.package_id_matchers = [
      /\b96\d{20}\b/ ,
      /\b\d{15}\b/ ,
      /\b\d{12}\b/ ,
      /\b((98\d{5}?\d{3}|98\d{2}) ?\d{4} ?\d{4}( ?\d{2})?)\b/ ,
    ]
  end
end

